\d .req

gb:{(24#"-"),16?.Q.an}                                                              //generate boundary marker
mult:{[b;d] "\r\n" sv mkpt[b]'[string key d;value d],enlist"--",b,"--"}             //build multipart

mkpt:{[b;n;v]
  /* create one part for a multipart form */
  f:-11=type v;                                                                     //check for file
  if[f;t:"Content-Type: ",$[0<count t:.h.ty last ` vs `$.url.sturl v;t;"application/octet-stream"],"\n"];     //get content-type for part
  r :"--",b,"\n";                                                                   //opening boundary
  r,:"Content-Disposition: form-data; name=\"",n,"\"",$[f;"; filename=",1_string v;""],"\n";
  r,:$[f;t;""],"\n",$[f;`char$read1 v;v];                                           //insert file contents or passed value
  :r;
 }

multi:{[d]
  /* covert a q dictionary to a multipart form */
  b:gb[];                                                                           //get boundary value
  m:mult[b;d];                                                                      //make multipart form from dictionary
  :((1#`$"Content-Type")!enlist"multipart/form-data; boundary=",b;m);               //return HTTP header & multipart form
 }

postmulti:{post[x] . multi y}                                                       //send HTTP POST report with multipart form

\d .