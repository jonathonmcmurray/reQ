.utl.require"req/b64.q"

.tst.desc["base64 enc/dec"]{
    should["encode b64"]{
        "dXNlcjpwYXNz" mustmatch .b64.enc"user:pass";
    };
    should["decode b64"]{
        "user:pass" mustmatch .b64.dec"dXNlcjpwYXNz";
    };
 };