\d .req

VERBOSE:@[value;`.req.VERBOSE;$[count .z.x;"-verbose" in .z.x;0b]];                 //default to non-verbose output

def:(!/) flip 2 cut (                                                               //default headers
  "Connection";     "Close";
  "User-Agent";     "kdb+/",string .Q.k;
  "Accept";         "*/*"
 )
ty:@[.h.ty;`form;:;"application/x-www-form-urlencoded"]                             //add type for url encoded form, used for slash commands
ty:@[ty;`json;:;"application/json"]                                                 //add type for JSON (missing in older versions of q)

proxy:{[h] /h-host for request
  /* get proxy address if needed for this hostname */
  p:(^/)`$getenv`$(floor\)("HTTP";"NO"),\:"_PROXY";                                 //check HTTP_PROXY & NO_PROXY env vars, upper & lower case - fill so p[0] is http_, p[1] is no_
  t:max(first ":"vs h)like/:{(("."=first x)#"*"),x}each"," vs string p 1;           //check if host is in NO_PROXY env var
  t:not null[first p]|t;                                                            //check if HTTP_PROXY is defined & host isn't in NO_PROXY
  :(t;p 0);                                                                         //return boolean of whether to use proxy & proxy address
 }

headers:{[us;pr;hd;p] /us-username,pr-proxy,hd-custom headers,p-payload
  /* build HTTP headers dictionary */
  d:def,$[count[us]&pr 0;                                                           //username & proxy
           enlist["Proxy-Authorization"]!enlist"Basic ",.b64.enc[us];               //add proxy-auth header
         count[us];                                                                 //username, no proxy
           enlist["Authorization"]!enlist"Basic ",.b64.enc[us];                     //add auth header
           ()];                                                                     //no additional header
  if[count p;d["Content-Length"]:string count p];                                   //if payload, add length header
  d,:$[11=type k:key hd;string k;k]!value hd;                                       //get headers dict (convert keys to strings if syms), append to defaults
  :d;
 }

enchd:{[d] /d-dictionary of headers
  /* convert KDB dictionary to HTTP headers */
  k:2_@[k;where 10<>type each k:(" ";`),key d;string];                              //convert non-string keys to strings
  v:2_@[v;where 10<>type each v:(" ";`),value d;string];                            //convert non-string values to strings
  :("\r\n" sv ": " sv/:flip (k;v)),"\r\n\r\n";                                      //encode headers dict to HTTP headers
 }

buildquery:{[m;pr;u;h;d;p] /m-method,pr-proxy,u-url,h-host,d-headers dict,p-payload
  /* construct full HTTP query string */
  uo:.url.parse0[0b;u];
  r:string[m]," ",$[pr 0;.url.sturl u;uo`path]," HTTP/1.1\r\n",                     //method & endpoint
       "Host: ",h,$[count d;"\r\n";""],                                             //add host string
       enchd[d],                                                                    //add headers
       $[count p;p;""];                                                             //add payload if present
  :r;                                                                               //return complete query string
 }

formatresp:{[r] /r-raw response
  /* split HTTP response into headers dict & body */
  p:(0,4+first r ss 4#"\r\n") cut r;                                                //split response headers & body
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
  uo:.url.parse0[0b] u;                                                             //parse URL into URL object
  pr:proxy h:uo`host;                                                               //check if we need to use proxy & get proxy address
  nu:$[@[value;`.doh.ENABLED;0b];.doh.resolve;]u;                                   //resolve URL via DNS-over-HTTPS if enabled
  nuo:.url.parse0[0b] nu;                                                           //parse URL into URL object
  hs:.url.hsurl `$raze uo`protocol`host;                                            //get hostname as handle
  if[pr[0];hs:.url.hsurl `$raze .url.parse0[0b;pr 1]`protocol`host];                //overwrite host handle if using proxy
  us:.url.parse0[0b;$[pr 0;pr 1;nu]]`auth;                                          //get user name (if present)
  if[count c:.cookie.getcookies[nuo`protocol;h;nuo`path];hd[`Cookie]:c];            //add any applicable cookies
  d:headers[us;pr;hd;p];                                                            //get dictionary of HTTP headers for request
  r:hs d:buildquery[m;pr;nu;h;d;p];                                                 //build query and execute
  if[v;-1"-- REQUEST --\n",string[hs],"\n",d];                                      //if verbose, log request
  if[v;-1"-- RESPONSE --\n",r];                                                     //if verbose, log response
  r:formatresp r;                                                                   //format response to headers & body
  if[(sc:`$"Set-Cookie") in k:key r 0;                                              //check for Set-Cookie headers
     .cookie.addcookie[h]'[value[r 0]where k=sc]];                                  //set any cookies necessary
  if[r[0][`status] within 300 399;                                                  //if status is 3XX, redirect FIX: not all 3XX are redirects?
     lo:$["/"=r[0][`Location]0;.url.format[`protocol`auth`host#uo],1_r[0]`Location;r[0]`Location]; //detect if relative or absolute redirect
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
