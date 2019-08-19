\d .req

// @kind function
// @category private
// @fileoverview Generate boundary marker
// @param x {any} Unused
// @return {string} Boundary marker
gb:{(24#"-"),16?.Q.an}
// @kind function
// @category private
// @fileoverview Build multi-part object
// @param b {string} boundary marker
// @param d {dict} headers (incl. file to be multiparted)
// @return {string} Multipart form
mult:{[b;d] "\r\n" sv mkpt[b]'[string key d;value d],enlist"--",b,"--"}             //build multipart

// @kind function
// @category private
// @fileoverview Create one part for a multipart form
// @param b {string} boundary marker
// @param n {string} name for form part
// @param v {string} value for form part
// @return {string[]} multipart form
mkpt:{[b;n;v]
  f:-11=type v;                                                                     //check for file
  t:"";                                                                             //placeholder for Content-Type
  if[f;t:"Content-Type: ",$[0<count t:.h.ty last` vs`$.url.sturl v;t;"application/octet-stream"],"\n"];     //get content-type for part
  r :"--",b,"\n";                                                                   //opening boundary
  r,:"Content-Disposition: form-data; name=\"",n,"\"",$[f;"; filename=",1_string v;""],"\n";
  r,:t,"\n",$[f;`char$read1 v;v];                                                   //insert file contents or passed value
  :r;
  }

// @kind function
// @category private
// @fileoverview Convert a q dictionary to a multipart form
// @param d {dict} kdb dictionary to convert to form
// @return {(dict;string)} (HTTP headers;body) to give to .req.post
multi:{[d]
  b:gb[];                                                                           //get boundary value
  m:mult[b;d];                                                                      //make multipart form from dictionary
  :((1#`$"Content-Type")!enlist"multipart/form-data; boundary=",b;m);               //return HTTP header & multipart form
  }

postmulti:{post[x] . multi y}                                                       //send HTTP POST report with multipart form

\d .
