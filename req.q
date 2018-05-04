\d .req

sturl:{(":"=first x)_x:$[-11=type x;string;]x}                                      //convert URL to string
hsurl:{hsym $[10=type x;`$;]x}                                                      //convert URL to hsym
prsu:{.Q.hap[x z]y}[$[.z.K<3.6;hsurl;sturl]]                                        //parse URL, string for 3.6+, hsym for below
prot:prsu[0]                                                                        //get protocol from URL
user:prsu[1]                                                                        //get username from URL
host:prsu[2]                                                                        //get hostname from URL
endp:prsu[3]                                                                        //get endpoint from URL
auth:{(neg[c]_.Q.b6 raze 64 vs'256 sv'"i"$0N 3#x,c#0),(c:mod[neg count x;3])#"="}   //base64 encode authorization
def:(!/) flip 2 cut (                                                               //default headers
  "Connection";     "Close";
  "User-Agent";     "kdb+/",string .Q.k;
  "Accept";         "*/*"
 )
ty:@[.h.ty;`form;:;"application/x-www-form-urlencoded"]                             //add type for url encoded form, used for slash commands
hu:.h.hug .Q.an,"-.~"                                                               //URI escaping for non-safe chars, RFC-3986

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
           enlist["Proxy-Authorization"]!enlist"Basic ",auth[us];                   //add proxy-auth header
         count[us];                                                                 //username, no proxy
           enlist["Authorization"]!enlist"Basic ",auth[us];                         //add auth header
           ()];                                                                     //no additional header
  if[count p;d["Content-Length"]:string count p];                                   //if payload, add length header
  d,:$[11=type k:key hd;string k;k]!value hd;                                       //get headers dict (convert keys to strings if syms), append to defaults
  :d;
 }

enchd:{[d] /d-dictionary of headers
  /* convert KDB dictionary to HTTP headers */
  :("\r\n" sv ": " sv/:flip (key;value)@\:d),"\r\n\r\n";                            //encode headers dict to HTTP headers
 }

buildquery:{[m;pr;u;h;d;p] /m-method,pr-proxy,u-url,h-host,d-headers dict,p-payload
  /* construct full HTTP query string */
  r:string[m]," ",$[pr 0;sturl u;endp[u]]," HTTP/1.1\r\n",                          //method & endpoint
       "Host: ",h,"\r\n",                                                           //add host string
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


urlencode:{[d] /d-dictionary
  /* encode a KDB dictionary as a URL encoded string */
  k:key d;v:value d;                                                                //split dictionary into keys & values
  v:enlist each hu each {$[10=type x;x;string x]}'[v];                              //string any values that aren't stringed,escape any chars that need it
  k:enlist each $[all 10=type each k;k;string k];                                   //if keys are strings, string them
  :"&" sv "=" sv' k,'v;                                                             //return urlencoded form of dictionary
 }

urldecode:{[x] /x-urlencoded string
  /* convert a URL encoded string to a KDB dictionary */
  :(!/)"S=&"0:.h.uh ssr[x;"+";" "];                                                 //parse incoming request into dict, replace escaped chars
 }

okstatus:{[x] /x-reponse (headers;body)
  /* throw a signal if not HTTP OK status */
  if[not x[0][`status] within 200 299;'string x[0]`status];                         //signal if bad status FIX: handle different status codes - descriptive signals
  :x;                                                                               //return response if it's not bad
 }

send:{[m;u;hd;p] /m-method,u-url,hd-headers,p-payload
  /* build & send HTTP request */
  pr:proxy h:host u;                                                                //check if we need to use proxy & get proxy address
  hs:hsym `$prot[u],h;                                                              //get hostname as handle & string
  if[pr[0];hs:hsym `$prot[pr 1],host pr 1];                                         //overwrite host handle if using proxy
  us:user $[pr 0;pr 1;u];                                                           //get user name (if present)
  d:headers[us;pr;hd;p];                                                            //get dictionary of HTTP headers for request
  r:hs buildquery[m;pr;u;h;d;p];                                                    //build query and execute
  r:formatresp r;                                                                   //format response to headers & body
  if[r[0][`status] within 300 399;                                                  //if status is 3XX, redirect FIX: not all 3XX are redirects?
     lo:$["/"=r[0][`Location]0;prot[u],user[u],host[u],r[0]`Location;r[0]`Location]; //detect if relative or absolute redirect
     :.z.s[m;lo;hd;p]];                                                             //perform redirections if needed
  :r;
 }

parseresp:{[r]
  /* detect JSON reponse & parse into KDB data structure */
  / TODO - add handling for other data types? /
  :$[r[0][`$"Content-Type"]like .h.ty[`json],"*";.j.k;] r[1];                       //check for JSON, parse if so
 }

.req.get:{parseresp okstatus send[`GET;x;y;()]}                                     //get - projection with no payload & GET method
.req.post:{parseresp okstatus send[`POST;x;y;z]}                                    //post - project with POST method

\d .
