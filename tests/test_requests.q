.utl.require"req"

// remove tracing header added by httpbin - messy to work with various types of return
// also ignore Host, as this changes depending on which httpbin we're testing with
.req.rmhd:{if[`headers in k:key x;x:k#((1#`headers)_x),(1#`headers)!enlist(`$"X-Amzn-Trace-Id";`Authorization;`Host;`Connection)_ x`headers];(1#`url) _ x};

// set fixed user agent for testing, so tests are not dependent on kdb version
.req.def["User-Agent"]:"kdb+/reQ-testing";

// httpbin URL to use for tests
TESTURL:"https://nghttp2.org/httpbin"

.tst.desc["Requests"]{
    before{
        `basePath mock ` sv (` vs .tst.tstPath)[0],`json;
        `rd mock {.req.rmhd (1#`origin)_ .j.k raze read0` sv x,y}[basePath];
    };
    should["Perform basic auth"]{
        `r mock rd`auth.json;
        r mustmatch .req.rmhd (1#`url) _ .req.g (8#TESTURL),"user:passwd@",(8_TESTURL),"/basic-auth/user/passwd";
    };
    should["Send custom headers"]{
        `r mock rd`headers.json;
        r mustmatch .req.rmhd (1#`url) _ .req.get[TESTURL,"/headers";`custom`headers!("with custom";"values")];
    };
    should["Follow HTTP redirects"]{
        `r mock rd`redirect.json;
        r mustmatch .req.rmhd `url`origin _ .req.g TESTURL,"/redirect/3";
    };
    should["Follow relative HTTP redirects"]{
        `r mock rd`rel_redirect.json;
        r mustmatch .req.rmhd `url`origin _ .req.g TESTURL,"/relative-redirect/3";
    };
    should["Follow absolute HTTP redirects"]{
        `r mock rd`abs_redirect.json;
        r mustmatch .req.rmhd `url`origin _ .req.g TESTURL,"/absolute-redirect/3";
    };
    should["Send POST request"]{
        `r mock rd`post.json;
        r mustmatch .req.rmhd `url`origin _ .req.post[TESTURL,"/post";enlist["Content-Type"]!enlist .req.ty`json;.j.j (1#`text)!1#`hello];
    };
    should["Set cookie"]{
        `r mock rd`setcookie.json;
        r mustmatch .req.rmhd (1#`url) _ .req.g TESTURL,"/cookies/set?abc=123&def=123";
    };
    should["Delete cookie"]{
        `r mock rd`deletecookie.json;
        r mustmatch .req.rmhd (1#`url) _ .req.g TESTURL,"/cookies/delete?abc";
    }
 };

