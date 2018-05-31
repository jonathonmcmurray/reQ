\l req.q
\l tests/k4unit.q

/ load JSON mock data - TODO replace this with binary mock data?
d:(first each ` vs'k)!(1#`origin)_/:.j.k each "\n" sv'read0 each ` sv' `:tests/json,'k:key`:tests/json;  //read expected responses
@[`d;;{$[`headers in key x;.[x;(`headers;`$"User-Agent");:;"kdb+/",string .Q.k];x]}]'[key d];            //update expected user-agent where applicable

\d .test

mock.cookiejar:get`:tests/mock/cookiejar                                                                 //read mock data - binary for correct typing
readjar:{mock[`cookiejar]~.req.readjar`:tests/cookiejar}                                                 //test reading cookiejar file
writejar:{[]                                                                                             //test writing cookiejar file
  .req.writejar[`:tests/cookiejar2;mock`cookiejar];
  r:read0[`:tests/cookiejar]~read0`:tests/cookiejar2;
  hdel`:tests/cookiejar2;
  :r;
 }

\d .

KUltf`:tests/tests.csv;
KUrt[];
show KUTR;
