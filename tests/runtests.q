d:(first each ` vs'k)!(1#`origin)_/:.j.k each "\n" sv'read0 each ` sv' `:tests/json,'k:key`:tests/json;  //read expected responses
@[`d;;{$[`headers in key x;.[x;(`headers;`$"User-Agent");:;"kdb+/",string .Q.k];x]}]'[key d];            //update expected user-agent where applicable

\l tests/k4unit.q
\l req.q

KUltf`:tests/tests.csv;
KUrt[];
show KUTR;
