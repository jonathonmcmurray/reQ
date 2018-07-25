/\l req.q
.utl.require"req"
\l tests/k4unit.q

/ load JSON mock data - TODO replace this with binary mock data?
d:(first each ` vs'k)!(1#`origin)_/:.j.k each "\n" sv'read0 each ` sv' `:tests/json,'k:key`:tests/json;  //read expected responses
@[`d;;{$[`headers in key x;.[x;(`headers;`$"User-Agent");:;"kdb+/",string .Q.k];x]}]'[key d];            //update expected user-agent where applicable

\d .test

mock.cookiejar:get`:tests/mock/cookiejar                                                                 //read mock data - binary for correct typing
readjar:{mock[`cookiejar]~.cookie.readjar`:tests/cookiejar}                                              //test reading cookiejar file
writejar:{[]                                                                                             //test writing cookiejar file
  .cookie.writejar[`:tests/cookiejar2;mock`cookiejar];
  r:read0[`:tests/cookiejar]~read0`:tests/cookiejar2;
  hdel`:tests/cookiejar2;
  :r;
 }

\d .

KUltf`:tests/tests.csv;
KUrt[];
show KUTR;

.cookie.jar:0#.cookie.jar;                                                                               //wipe cookies
KUTR:0#KUTR;                                                                                             //wipe results

-1 string[.z.Z]," re-run tests with DNS-over-HTTPS";
\l doh_google.q
KUrt[];
show KUTR;
