.utl.require"req"

// remove tracing header added by httpbin - messy to work with various types of return
.req.rmhd:{if[`headers in k:key x;x:k#((1#`headers)_x),(1#`headers)!enlist(`$"X-Amzn-Trace-Id")_ x`headers];x};

.tst.desc["Requests"]{
    before{
        `basePath mock ` sv (` vs .tst.tstPath)[0],`json;
        `rd mock {(1#`origin)_ .j.k raze read0` sv x,y}[basePath];
    };
    should["Perform basic auth"]{
        `r mock rd`auth.json;
        r mustmatch .req.rmhd .req.g"https://user:passwd@httpbin.org/basic-auth/user/passwd";
    };
    should["Send custom headers"]{
        `r mock rd`headers.json;
        r mustmatch .req.rmhd .req.get["https://httpbin.org/headers";`custom`headers!("with custom";"values")];
    };
    should["Follow HTTP redirects"]{
        `r mock rd`redirect.json;
        r mustmatch .req.rmhd (1#`origin)_ .req.g"https://httpbin.org/redirect/3";
    };
    should["Follow relative HTTP redirects"]{
        `r mock rd`rel_redirect.json;
        r mustmatch .req.rmhd (1#`origin)_ .req.g"https://httpbin.org/relative-redirect/3";
    };
    should["Follow absolute HTTP redirects"]{
        `r mock rd`abs_redirect.json;
        r mustmatch .req.rmhd (1#`origin)_ .req.g"https://httpbin.org/absolute-redirect/3";
    };
    should["Send POST request"]{
        `r mock rd`post.json;
        r mustmatch .req.rmhd (1#`origin)_ .req.post["https://httpbin.org/post";enlist["Content-Type"]!enlist .req.ty`json;.j.j (1#`text)!1#`hello];
    };
    should["Set cookie"]{
        `r mock rd`setcookie.json;
        r mustmatch .req.rmhd .req.g"https://httpbin.org/cookies/set?abc=123&def=123";
    };
    should["Delete cookie"]{
        `r mock rd`deletecookie.json;
        r mustmatch .req.rmhd .req.g"https://httpbin.org/cookies/delete?abc";
    }
 };