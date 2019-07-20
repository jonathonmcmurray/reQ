# User API

---

*NOTE: The public API is still being defined & is subject to change. However, the
majority of the functions should not change in usage or functionality.*

The main entry points for the library are via wrapper functions for a number of
HTTP methods; `.req.get`, `.req.post`, `.req.delete`. Additionally, there is a
simple wrapper for GET requests which do not require custom headers, `.req.g`,
which is meant as a drop in replacement for `.Q.hg` with the enhanced features
of reQ.

Each request function will provide the following features:

* Store & send [cookies](features/cookies.md) as appropriate
* Follow [HTTP redirects](features/redirects.md)
* Automatically parse JSON responses

The first argument to each function is always the URL for the request,
including any URL parameters, and can be passed as a string, hsym or symbol.
If sending numerous requests to the same host but with different URL parameters
it is advisable to use strings, to avoid bloating internalised sym vector.

# Functions

---

#### `.req.get`
`[url;headers]`

* *url*: URL to send request to, as string, hsym or symbol
* *headers*: KDB dictionary of custom headers to add to HTTP request

*Example*

```q
$ q req.q
KDB+ 3.5 2017.10.11 Copyright (C) 1993-2017 Kx Systems
l32/ 2()core 1945MB jonny grizzly 127.0.1.1 NONEXPIRE

q).Q.hg`:http://httpbin.org/headers
"{\n  \"headers\": {\n    \"Connection\": \"close\", \n    \"Host\": \"httpbin.org\"\n  }\n}\n"
q).req.get["http://httpbin.org/headers";`custom`headers!("with custom";"values")]
       | Accept Connection Custom        Headers  Host          User-Agent
-------| -----------------------------------------------------------------
headers| "*/*"  "close"    "with custom" "values" "httpbin.org" "kdb+/3.5"
```

---

#### `.req.post`
`[url;headers;body]`

 * *url*: URL to send request to, as string, hsym or symbol
 * *headers*: KDB dictionary of custom headers to add to HTTP request
 * *body*: request body, as a string -> where necessary, `Content-Type` should be set in header dict manually. `Content-Length` will be added automatically

*Note:* In a future update, it will be possible to pass the body in a more user friendly way, see [jonatonmcmurray/reQ#7](https://github.com/jonathonmcmurray/reQ/issues/7)

*Example*

```q
q).req.post["http://httpbin.org/post";enlist["Content-Type"]!enlist .req.ty`json;.j.j (1#`text)!1#`hello]
args   | (`symbol$())!()
data   | "{\"text\":\"hello\"}"
files  | (`symbol$())!()
form   | (`symbol$())!()
headers| `Accept`Connection`Content-Length`Content-Type`Host`User-Agent!("*/*";"close";"16";"application/json";"httpbin.org";"kdb+/3.5")
json   | (,`text)!,"hello"
origin | "146.199.80.196"
url    | "http://httpbin.org/post"
```

---

#### `.req.delete`
`[url;headers;body]`

 * *url*: URL to send request to, as string, hsym or symbol
 * *headers*: KDB dictionary of custom headers to add to HTTP request
 * *body*: request body, as a string -> where necessary, `Content-Type` should be set in header dict manually. `Content-Length` will be added automatically

*Note:* In a future update, it will be possible to pass the body in a more user friendly way, see [jonatonmcmurray/reQ#7](https://github.com/jonathonmcmurray/reQ/issues/7)

*Example*

```q
q).req.delete["http://httpbin.org/delete";()!();()]
args   | (`symbol$())!()
data   | ""
files  | (`symbol$())!()
form   | (`symbol$())!()
headers| `Accept`Connection`Content-Length`Host`User-Agent!("*/*";"close";,"0";"httpbin.org";"kdb+/3.5")
json   | 0n
origin | "86.145.98.64"
url    | "http://httpbin.org/delete"
```

---

#### `.req.g`
`[url]`

Projection to send a simple GET request with no custom headers

 * *url*: URL to send request to, as string, hsym or symbol

*Example*

```q
q).req.g"http://httpbin.org/get"
args   | (`symbol$())!()
headers| `Accept`Connection`Host`User-Agent!("*/*";"close";"httpbin.org";"kdb+/3.5")
origin | "86.145.98.64"
url    | "http://httpbin.org/get"
```

---

#### `.req.del`
`[url;headers]`

Projection to send DELETE request with no body

 * *url*: URL to send request to, as string, hsym or symbol
 * *headers*: KDB dictionary of custom headers to add to HTTP request

*Example*

```q
q).req.del["http://httpbin.org/delete";`with`custom!("headers";"123")]
args   | (`symbol$())!()
data   | ""
files  | (`symbol$())!()
form   | (`symbol$())!()
headers| `Accept`Connection`Content-Length`Custom`Host`User-Agent`With!("*/*";"close";,"0";"123";"httpbin.org";"kdb+/3.5";"headers")
json   | 0n
origin | "86.145.98.64"
url    | "http://httpbin.org/delete"
```

---

#### `.req.d`
`[url]`

Projection to send simple DELETE requests with no body or headers

 * *url*: URL to send request to, as string, hsym or symbol

 *Example*

```q
q).req.d"http://httpbin.org/delete"
args   | (`symbol$())!()
data   | ""
files  | (`symbol$())!()
form   | (`symbol$())!()
headers| `Accept`Connection`Content-Length`Host`User-Agent!("*/*";"close";,"0";"httpbin.org";"kdb+/3.5")
json   | 0n
origin | "86.145.98.64"
url    | "http://httpbin.org/delete"
```