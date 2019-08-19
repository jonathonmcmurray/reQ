\d .req

// @kind function
// @category public
// @subcategory experimenal
// @fileoverview *EXPERIMENTAL* send a request with a client-side timeout
// @param t {int|long} timeout (seconds)
// @param m {symbol} HTTP method/verb
// @param u {symbol|string|#hsym} URL
// @param hd {dict} dictionary of custom HTTP headers to use
// @param p {string} payload/body (for POST requests)
// @return {(dict;string)} HTTP response (headers;body)
timeout:{[t;m;u;hd;p]
  ot:system"T";system"T ",string t;                                                 //store old timeout & set new
  r:@[0;(`.req.send;m;u;hd;p;VERBOSE);{x}];                                         //send request & trap error
  system"T ",string ot;                                                             //reset timeout
  :$[r~"stop";'"timeout";r];                                                        //return or signal
  }

\d .
