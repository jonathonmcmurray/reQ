.utl.require"req/cookie.q"

.tst.desc["Cookies"]{
    before{
        `basePath mock (` vs .tst.tstPath)[0];
        `r mock get ` sv basePath,`mock`cookiejar;
    };
    should["read cookie jar"]{
        r mustmatch .cookie.readjar ` sv basePath,`cookiejar;
    };
    should["write cookie jar"]{
        .cookie.writejar[` sv basePath,`cookiejar2;r];
        read0[` sv basePath,`cookiejar2] mustmatch read0[` sv basePath,`cookiejar];
        hdel ` sv basePath,`cookiejar2;
    };
 };