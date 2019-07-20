.utl.require"req"

.tst.desc["Requests"]{
    before{
        `basePath mock ` sv (` vs .tst.tstPath)[0],`json;
        `rd mock {(1#`origin)_ .j.k raze read0` sv x,y}[basePath];
    };
    should["Perform basic auth"]{
        `r mock rd`auth.json;
        r mustmatch .req.g"http://user:passwd@httpbin.org/basic-auth/user/passwd";
    };
    should["Send custom headers"]{
        `r mock rd`headers.json;
        r mustmatch .req.get["http://httpbin.org/headers";`custom`headers!("with custom";"values")];
    };
    should["Follow HTTP redirects"]{
        `r mock rd`redirect.json;
        r mustmatch  (1#`origin)_ .req.g"http://httpbin.org/redirect/3";
    };
    should["Follow relative HTTP redirects"]{
        `r mock rd`rel_redirect.json;
        r mustmatch  (1#`origin)_ .req.g"http://httpbin.org/relative-redirect/3";
    };
    should["Follow absolute HTTP redirects"]{
        `r mock rd`abs_redirect.json;
        r mustmatch  (1#`origin)_ .req.g"http://httpbin.org/absolute-redirect/3";
    };
    should["Send POST request"]{
        `r mock rd`post.json;
        r mustmatch (1#`origin)_ .req.post["http://httpbin.org/post";enlist["Content-Type"]!enlist .req.ty`json;.j.j (1#`text)!1#`hello];
    };
    should["Set cookie"]{
        `r mock rd`setcookie.json;
        r mustmatch .req.g"http://httpbin.org/cookies/set?abc=123&def=123";
    };
    should["Delete cookie"]{
        `r mock rd`deletecookie.json;
        r mustmatch .req.g"http://httpbin.org/cookies/delete?abc";
    }
 };