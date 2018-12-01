\d .req

VERBOSE:@[value;`.req.VERBOSE;$[count .z.x;"-verbose" in .z.x;0b]];                 //default to non-verbose output

def:(!/) flip 2 cut (                                                               //default headers
  "Connection";     "Close";
  "User-Agent";     "kdb+/",string .Q.k;
  "Accept";         "*/*"
  )
query:`method`url`hsym`path`headers`body`bodytype!()                                //query object template

ty:@[.h.ty;`form;:;"application/x-www-form-urlencoded"]                             //add type for url encoded form, used for slash commands
ty:@[ty;`json;:;"application/json"]                                                 //add type for JSON (missing in older versions of q)

proxy:{[u] /u-URL object
  /* get proxy address if needed for this hostname */
  p:(^/)`$getenv`$(floor\)("HTTP";"NO"),\:"_PROXY";                                 //check HTTP_PROXY & NO_PROXY env vars, upper & lower case - fill so p[0] is http_, p[1] is no_
  t:max(first ":"vs u[`url]`host)like/:{(("."=first x)#"*"),x}each"," vs string p 1; //check if host is in NO_PROXY env var
  t:not null[first p]|t;                                                            //check if HTTP_PROXY is defined & host isn't in NO_PROXY
  :$[t;@[;`proxy;:;p 0];]u;                                                         //add proxy to URL object if required
 }

addheaders:{[q] /q-query object
  /* build HTTP headers dictionary */
  d:def;
  if[count q[`url;`auth];d[$[`proxy in key q;"Proxy-";""],"Authorization"]:"Basic ",.b64.enc q[`url;`auth]];
  if[count q`body;d["Content-Length"]:string count q`body];                         //if payload, add length header
  d,:$[11=type k:key q`headers;string k;k]!value q`headers;                         //get headers dict (convert keys to strings if syms), append to defaults
  :@[q;`headers;:;d];
 }

enchd:{[d] /d-dictionary of headers
  /* convert KDB dictionary to HTTP headers */
  k:2_@[k;where 10<>type each k:(" ";`),key d;string];                              //convert non-string keys to strings
  v:2_@[v;where 10<>type each v:(" ";`),value d;string];                            //convert non-string values to strings
  :("\r\n" sv ": " sv/:flip (k;v)),"\r\n\r\n";                                      //encode headers dict to HTTP headers
 }

buildquery:{[q] /q-query
  /* construct full HTTP query string */
  r:string[q`method]," ",q[`url;`path]," HTTP/1.1\r\n",                             //method & endpoint TODO: fix q[`path] for proxy use case
  "Host: ",q[`url;`host],$[count d;"\r\n";""],                                      //add host string
       enchd[q`headers],                                                            //add headers
       $[count q`body;q`body;""];                                                   //add payload if present
  :r;                                                                               //return complete query string
 }

formatresp:{[r] /r-raw response
  /* split HTTP response into headers dict & body */
  p:(0,4+first r ss 4#"\r\n") cut r;                                                //split response headers & body
  p:@[p;0;"statustext:",];                                                          //add key for status text line
  d:trim enlist[`]_(!/)("S:\n")0:p[0]except"\r";                                    //create dictionary of response headers
  d[`status]:"I"$(" "vs r)1;                                                        //add status code
  :(d;p[1]);                                                                        //return header dict & reponse body
 } 

okstatus:{[v;x] /v-verbose flag,x-reponse (headers;body)
  /* throw a signal if not HTTP OK status */
  if[v|x[0][`status] within 200 299;:x];                                            //if in verbose mode or OK status, return
  'string x[0]`status;                                                              //signal if bad status FIX: handle different status codes - descriptive signals
 }

send:{[m;u;hd;p;v] /m-method,u-url,hd-headers,p-payload,v-verbose flag
  /* build & send HTTP request */
  q:@[query;`method`url`headers`body;:;(m;.url.parse0[0]u;hd;p)];                   //parse URL into URL object & build query
  q:proxy q;                                                                        //check if we need to use proxy & get proxy address
  /nu:$[@[value;`.doh.ENABLED;0b];.doh.resolve;]u;                                   //resolve URL via DNS-over-HTTPS if enabled
  hs:.url.hsurl`$raze q ./:enlist[`url`protocol],$[`proxy in key q;1#`proxy;enlist`url`host]; //get hostname as handle
  q:.cookie.addcookies[q];                                                          //add cookie headers
  q:addheaders[q];                                                                  //get dictionary of HTTP headers for request
  r:hs d:buildquery[q];                                                             //build query and execute
  if[v;-1"-- REQUEST --\n",string[hs],"\n",d];                                      //if verbose, log request
  if[v;-1"-- RESPONSE --\n",r];                                                     //if verbose, log response
  r:formatresp r;                                                                   //format response to headers & body
  if[(sc:`$"Set-Cookie") in k:key r 0;                                              //check for Set-Cookie headers
      .cookie.addcookie[q[`url;`host]]'[value[r 0]where k=sc]];                     //set any cookies necessary
  if[r[0][`status] within 300 399;                                                  //if status is 3XX, redirect FIX: not all 3XX are redirects?
      lo:$["/"=r[0][`Location]0;.url.format[`protocol`auth`host#q`url],1_r[0]`Location;r[0]`Location]; //detect if relative or absolute redirect
     :.z.s[m;lo;hd;p;v]];                                                           //perform redirections if needed
  :r;
 }

parseresp:{[r]
  /* detect JSON reponse & parse into KDB data structure */
  / TODO - add handling for other data types? /
  :$[(`j in key`)&r[0][`$"Content-Type"]like .h.ty[`json],"*";.j.k;] r[1];          //check for JSON, parse if so
 }

.req.get:{parseresp okstatus[VERBOSE] send[`GET;x;y;();VERBOSE]}                    //get - projection with no payload & GET method
.req.g:.req.get[;()!()]                                                             //simple get, no custom headers
.req.post:{parseresp okstatus[VERBOSE] send[`POST;x;y;z;VERBOSE]}                   //post - project with POST method
.req.delete:{parseresp okstatus[VERBOSE] send[`DELETE;x;y;z;VERBOSE]}               //delete - project with DELETE method
.req.del:.req.delete[;;()]                                                          //project with no body
.req.d:.req.del[;()!()]                                                             //project with no body or headers

\d .
