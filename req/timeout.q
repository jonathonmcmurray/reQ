\d .req

timeout:{[t;m;u;hd;p]
  ot:system"T";system"T ",string t;                                                 //store old timeout & set new
  r:@[0;(`.req.send;m;u;hd;p;VERBOSE);{x}];                                             //send request & trap error
  system"T ",string ot;                                                             //reset timeout
  :$[r~"stop";'"timeout";r];                                                        //return or signal
 }

\d .