# Configuring default behaviours

---

## `.req.PARSE`

Controls whether standard functions (`.req.get` etc.) will attempt to parse
response into kdb datatypes (e.g. parsing JSON response).

If disabled, raw string response will be returned with headers

By default, `.req.PARSE` is set to `1b`; to disable parsing, set to `0b`.

e.g.

```q
q).req.PARSE:0b
q).req.g"http://httpbin.org/get"
`statustext`date`content-type`content-length`connection`server`access-control-allow-origin`access-control-allow-credentials`status!("HTTP/1.1 200 OK";"Fri, 05 Jun 2020 17:08:08 GMT";"application/json";"328";"close";"gunicorn/19.9.0";,"*..
"{\n  \"args\": {}, \n  \"headers\": {\n    \"Accept\": \"*/*\", \n    \"Accept-Encoding\": \"gzip\", \n    \"Authorization\": \"Basic cmVROnJlcXBhc3M=\", \n    \"Host\": \"httpbin.org\", \n    \"User-Agent\": \"kdb+/4\", \n    \"X-Amzn..
q).req.PARSE:1b
q).req.g"http://httpbin.org/get"
args   | (`symbol$())!()
headers| `Accept`Accept-Encoding`Authorization`Host`User-Agent`X-Amzn-Trace-Id!("*/*";"gzip";"Basic cmVROnJlcXBhc3M=";"httpbin.org";"kdb+/4";"Root=1-5eda7bfd-92527fb727e9b8b07de0bb8a")
origin | "90.249.66.28"
url    | "http://httpbin.org/get"
```

## `.req.SIGNAL`

Controls whether reQ will throw a signal when encountering an HTTP error
status (i.e. 4XX status code).

By default, `.req.SIGNAL` is set to `1b`; to disable signalling, set to `0b`.

e.g.

```q
q).req.SIGNAL:0b
q).req.g"http://httpbin.org/status/403"
""
q).req.SIGNAL:1b
q).req.g"http://httpbin.org/status/403"
'403
  [2]  /home/jonny/git/reQ/req/req.q:116: .req.okstatus:
  if[not[.req.SIGNAL]|v|x[0][`status] within 200 299;:x];                           //if signalling disabled, in verbose mode or OK status, return
  'string x[0]`status;                                                              //signal if bad status FIX: handle different status codes - descriptive signals
  ^
  }
  [1]  /home/jonny/git/reQ/req/req.q:169: .req.get:{parseresp okstatus[.req.VERBOSE] send[`GET;x;y;();.req.VERBOSE]}
                                                              ^
q.req))\
```
