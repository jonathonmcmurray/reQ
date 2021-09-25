\d .req

// @kind data
// @category variable
// @fileoverview Flag for verbose mode
VERBOSE:@[value;`.req.VERBOSE;0i];                                                  //default to non-verbose output

// @kind data
// @category variable
// @fileoverview Flag for parsing output to q datatypes
PARSE:@[value;`.req.PARSE;1b];                                                      //default to parsing output

// @kind data
// @category variable
// @fileoverview Flag for signalling on HTTP errors
SIGNAL:@[value;`.req.SIGNAL;1b];                                                    //default to signalling for HTTP errors

// @kind data
// @category variable
// @fileoverview Default headers added to all HTTP requests
def:(!/) flip 2 cut (                                                               //default headers
  "Connection";     "Close";
  "User-Agent";     "kdb+/",string .Q.k;
  "Accept";         "*/*"
  )
if[.z.K>=3.7;def["Accept-Encoding"]:"gzip"];                                        //accept gzip compressed responses on 3.7+
query:`method`url`hsym`path`headers`body`bodytype!()                                //query object template

// @kind data
// @category variable
// @fileoverview Dictionary with Content-Types
ty:@[.h.ty;`form;:;"application/x-www-form-urlencoded"]                             //add type for url encoded form, used for slash commands
ty:@[ty;`json;:;"application/json"]                                                 //add type for JSON (missing in older versions of q)

// @kind data
// @category variable
// @fileoverview Dictionary with Content-Type encoders
tx:@[.h.tx;`form;:;.url.enc]                                                        //add encoder for url encoded form
tx:@[tx;`json;:;.j.j]                                                               //encode with .j.j rather than json lines encoder

// @kind data
// @category variable
// @fileoverview Dictionary with decompress functions for Content-Encoding types
decompress:enlist[enlist""]!enlist(::)
// use native gzip decompression where available
if[.z.K>=3.7;decompress[enlist"gzip"]:-35!];

// @kind function
// @category private
// @fileoverview Applies proxy if relevant
// @param u {dict} URL object
// @return {dict} Updated URL object
proxy:{[u]
  p:(^/)`$getenv`$(floor\)("HTTP";"NO"),\:"_PROXY";                                 //check HTTP_PROXY & NO_PROXY env vars, upper & lower case - fill so p[0] is http_, p[1] is no_
  t:max(first ":"vs u[`url]`host)like/:{(("."=first x)#"*"),x}each"," vs string p 1; //check if host is in NO_PROXY env var
  t:not null[first p]|t;                                                            //check if HTTP_PROXY is defined & host isn't in NO_PROXY
  :$[t;@[;`proxy;:;p 0];]u;                                                         //add proxy to URL object if required
  }

// @kind function
// @category private
// @fileoverview Convert headers to strings & add authorization and Content-Length
// @param q {dict} query object
// @return {dict} Updated query object
addheaders:{[q]
  d:.req.def;
  if[count q[`url;`auth];d[$[`proxy in key q;"Proxy-";""],"Authorization"]:"Basic ",.b64.enc q[`url;`auth]];
  if[count q`body;d["Content-Length"]:string count q`body];                         //if payload, add length header
  d,:$[11=type k:key q`headers;string k;k]!value q`headers;                         //get headers dict (convert keys to strings if syms), append to defaults
  :@[q;`headers;:;d];
  }

// @kind function
// @category private
// @fileoverview Convert a KDB dictionary into HTTP headers
// @param d {dict} dictionary of headers
// @return {string} string HTTP headers
enchd:{[d]
  k:2_@[k;where 10<>type each k:(" ";`),key d;string];                              //convert non-string keys to strings
  v:2_@[v;where 10<>type each v:(" ";`),value d;string];                            //convert non-string values to strings
  :("\r\n" sv ": " sv/:flip (k;v)),"\r\n\r\n";                                      //encode headers dict to HTTP headers
  }

// @kind function
// @category private
// @fileoverview Construct full HTTP query string from query object
// @param q {dict} query object
// @return {string} HTTP query string
buildquery:{[q]
  r:string[q`method]," ",q[`url;`path]," HTTP/1.1\r\n",                             //method & endpoint TODO: fix q[`path] for proxy use case
  "Host: ",q[`url;`host],$[count q`headers;"\r\n";""],                              //add host string
       enchd[q`headers],                                                            //add headers
       $[count q`body;q`body;""];                                                   //add payload if present
  :r;                                                                               //return complete query string
  }

// @kind function
// @category private
// @fileoverview Split HTTP response into headers & dict
// @param r {string} raw HTTP response
// @return {(dict;string;string)} (response header;response body;raw headers)
formatresp:{[r]
  p:(0,4+first r ss 4#"\r\n") cut r;                                                //split response headers & body
  rh:p 0;                                                                           //keep raw headers to return as text
  p:@[p;0;"statustext:",];                                                          //add key for status text line
  d:trim enlist[`]_(!/)("S:\n")0:p[0]except"\r";                                    //create dictionary of response headers
  d:lower[key d]!value d;                                                           //make headers always lower case
  d[`status]:"I"$(" "vs r)1;                                                        //add status code
  if[(`$"content-encoding")in key d;
      p[1]:.req.decompress[d`$"content-encoding"]p[1];                              //if compressed, decompress body based on content-encoding
    ];
  :(d;p[1];rh);                                                                     //return header dict, reponse body, raw headers string
  }

// @kind function
// @category private
// @fileoverview Signal if not OK status, return unchanged response if OK
// @param v {boolean} verbose flag
// @param x {(dict;string)} HTTP response object
// @return {(dict;string)} HTTP response object
okstatus:{[v;x]
  if[not[.req.SIGNAL]|v|x[0][`status] within 200 299;:x];                           //if signalling disabled, in verbose mode or OK status, return
  'string x[0]`status;                                                              //signal if bad status FIX: handle different status codes - descriptive signals
  }

// @kind function
// @category public
// @fileoverview Send an HTTP request
// @param m {symbol} HTTP method/verb
// @param u {symbol|string|#hsym} URL
// @param hd {dict} dictionary of custom HTTP headers to use
// @param p {string} payload/body (for POST requests)
// @param v {boolean} verbose flag
// @return {(dict;string)} HTTP response (headers;body)
send:{[m;u;hd;p;v]
  u:$[type u;enlist;]u;                                                             //allow URL to contain query dict as 2nd element of the list
  q:@[.req.query;`method`url`headers`body;:;(m;.url.parse0[0]u 0;hd;p)];            //parse URL into URL object & build query
  if[count u 1; q[`url;`path]:.url.format `path`query!(q[`url;`path];u 1)];         //if query dict supplied, incorporate it in the URL path
  if[a:count q[`url]`auth;.auth.setcache . q[`url]`host`auth];                      //cache credentials if set
  if[not a;q[`url;`auth]:.auth.getcache q[`url]`host];                              //retrieve cached credentials if not set
  q:proxy q;                                                                        //check if we need to use proxy & get proxy address
  /nu:$[@[value;`.doh.ENABLED;0b];.doh.resolve;]u 0;                                //resolve URL via DNS-over-HTTPS if enabled
  hs:.url.hsurl`$raze q ./:enlist[`url`protocol],$[`proxy in key q;1#`proxy;enlist`url`host]; //get hostname as handle
  q:.cookie.addcookies[q];                                                          //add cookie headers
  q:addheaders[q];                                                                  //get dictionary of HTTP headers for request
  r:hs d:buildquery[q];                                                             //build query and execute
  if[v;neg[`int$v]"-- REQUEST --\n",string[hs],"\n",d];                             //if verbose, log request
  r:formatresp r;                                                                   //format response to headers & body
  if[v;neg[`int$v]"-- RESPONSE --\n",r[2],"\n\n",r[1],("\n"<>last r[1])#"\n"];      //if verbose, log response
  if[(sc:`$"set-cookie") in k:key r 0;                                              //check for Set-Cookie headers
      .cookie.addcookie[q[`url;`host]]'[value[r 0]where k=sc]];                     //set any cookies necessary
  if[r[0][`status]=401;:.z.s[m;.auth.getauth[r 0;u 0];hd;p;v]];                     //if unauthorised prompt for user/pass FIX:should have some counter to prevent infinite loops
  if[.status.class[r] = 3;                                                          //if status is 3XX, redirect
      lo:$["/"=r[0][`location]0;.url.format[`protocol`auth`host#q`url],1_r[0]`location;r[0]`location]; //detect if relative or absolute redirect
     :.z.s[m;lo;hd;p;v]];                                                           //perform redirections if needed
  :r;
  }

// @kind function
// @category private
// @fileoverview Parse to kdb object based on Content-Type header. Only supports JSON currently
// @param r {(dict;string)} HTTP respone
// @return {any} Parsed response
parseresp:{[r]
  / TODO - add handling for other data types? /
  if[not .req.PARSE;:2#r];                                                          //if parsing disabled, return "raw" response (incl. headers dict)
  f:$[(`j in key`)&r[0][`$"content-type"]like .req.ty[`json],"*";.j.k;::];          //check for JSON, parse if so
  :@[f;r[1];r[1]];                                                                  //error trap parsing, return raw if fail
  }

// @kind function
// @category public
// @fileoverview Send an HTTP GET request
// @param x {symbol|string|#hsym} URL
// @param y {dict} dictionary of custom HTTP headers to use
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
// @qlintsuppress RESERVED_NAME
.req.get:{parseresp okstatus[.req.VERBOSE] send[`GET;x;y;();.req.VERBOSE]}

// @kind function
// @category public
// @fileoverview Send an HTTP GET request (simple, no custom headers)
// @param x {symbol|string|#hsym} URL
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
.req.g:.req.get[;()!()]

// @kind function
// @category public
// @fileoverview Send an HTTP POST request
// @param x {symbol|string|#hsym} URL
// @param y {dict} dictionary of custom HTTP headers to use
// @param z {string} body for HTTP request
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
.req.post:{parseresp okstatus[.req.VERBOSE] send[`POST;x;y;z;.req.VERBOSE]}

// @kind function
// @category public
// @fileoverview Send an HTTP POST request (no custom headers)
// @param x {symbol|string|#hsym} URL
// @param y {dict} symbol of encoding to use (e.g. `` `json `csv``)
// @param z {string|any} body for HTTP request (if non-string, must be an encoder in .req.tx)
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
.req.p:{[x;y;z]
  if[10h<>type z;
    if[not y in key .req.tx;'type];
    z:.req.tx[y] z;
  ];
  y:enlist["Content-Type"]!enlist .req.ty y;
  parseresp okstatus[.req.VERBOSE] send[`POST;x;y;z;.req.VERBOSE]}

// @kind function
// @category public
// @fileoverview Send an HTTP DELETE request
// @param x {symbol|string|#hsym} URL
// @param y {dict} dictionary of custom HTTP headers to use
// @param z {string} body for HTTP request
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
// @qlintsuppress RESERVED_NAME
.req.delete:{parseresp okstatus[.req.VERBOSE] send[`DELETE;x;y;z;.req.VERBOSE]}

// @kind function
// @category public
// @fileoverview Send an HTTP DELETE request, no body
// @param x {symbol|string|#hsym} URL
// @param y {dict} dictionary of custom HTTP headers to use
// @return {(dict;string)|any} HTTP response (headers;body), or parsed if JSON
.req.del:.req.delete[;;()]

\d .

