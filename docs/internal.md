# Internal Functions

*Warning: The functions documented here are internal functions used by the
library. While most of these are unlikely to change in usage in future versions
be aware this is possible and take care if using these functions directly*

Below is preliminary documentation of internal functions, more detail will be
added in time.

---

#### `.req.addcookie`
`[host;cookiestring]`

The function called internally when a `Set-Cookie` header is received on an
HTTP response, taking the host for the request & the cookie header string as
arguments.

```
q).req.addcookie["adventofcode.com";"session=n0tar34ls3ss10nc00k13"]
q).req.cookiejar
host               path name     | val                     expires maxage secure httponly samesite
---------------------------------| ---------------------------------------------------------------
"adventofcode.com" ,"*" "session"| "n0tar34ls3ss10nc00k13"                0      0
```

#### `.req.getcookies`
`[protocol;host;path]`

Get applicable cookies from cookiejar for given protocol, host & path

#### `.req.readjar`
`[file]`

Read cURL/Netscape format cookiejar into reQ internal cookiejar format

use `` `.req.cookiejar upsert .req.readjar[`:file]`` to update internal jar

#### `.req.writejar`
`[file;jar]`

Write internal reQ cookiejar to file in cURL/Netscape format

#### `.req.sturl`
`[url]`

Get string form of URL, given symbol, hsym or string

#### `.req.hsurl`
`[url]`

Get hsym form of URL, given symbol, hsym or string

#### `.req.hap`
`[url]`

Split URL into protocol, username:pass, domain & path. Accept string, hsym or
symbol.

#### `.req.prot`
`[url]`

Extract protocol from URL

#### `.req.user`
`[url]`

Extract username:pass from URL

#### `.req.host`
`[url]`

Extract domain from URL

#### `.req.endp`
`[url]`

Extract endpoint/path from URL

#### `.req.b64encode`
`[string]`

base64 encode a string (e.g. for HTTP Basic Authentication)

#### `.req.b64decode`
`[string]`

base64 decode a string

#### `.req.ty`

Extended version of `.h.ty` dictionary mapping `Content-Type` strings to
simple symbols

#### `.req.hu`
`[string]`

Escape URI non-safe characters, based on RFC-3986 (more updated spec than `.h.hu`)

#### `.req.proxy`
`[host]`

Check if proxy is required for given host

#### `.req.headers`
`[username;proxy;headers;payload]`

Generate HTTP headers from combination of defaults & custom headers, adding
proxy headers if necessary & `Content-Length` for payload

#### `.req.enchd`
`[headers]`

Convert a kdb dictionary to HTTP headers

#### `.req.buildquery`
`[method;proxy;url;host;headers;payload]`

Build HTTP query string including necessary headers etc.

#### `.req.formatresp`
`[response]`

Split HTTP response into header dictionary & body

#### `.req.urlencode`
`[dict]`

Convert a kdb dictionary to a URL encoded string

#### `.req.urldecode`
`[string]`

Convert a URL encoded string to a kdb dictionary

#### `.req.okstatus`
`[verbose;response]`

Check status of response & signal if bad

#### `.req.send`
`[method;url;headers;payload;verbose]`

Entry point for sending any type of HTTP request

#### `.req.parseresp`
`[resp]`

If response has `Content-Type: application/json`, parse to kdb object. (Other
formats may be added in future)