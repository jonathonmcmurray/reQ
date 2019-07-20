# Verbose mode

---

reQ includes a verbose mode which displays the raw HTTP requests & responses.
This can be useful for debugging purposes, to view the full headers on both the
request & response.

To enable this mode, either start the process with `-verbose` on the command
line, or else set `.req.VERBOSE:1b` before making the requests.

## Examples

Setting `-verbose` on command line & performing a basic HTTP request:

```
jonny@kodiak ~/reQ (master) $ q req.q -verbose
KDB+ 3.5 2018.04.25 Copyright (C) 1993-2018 Kx Systems
l64/ 4(16)core 7360MB jonny kodiak 127.0.1.1 EXPIRE 2019.05.21 jonathon.mcmurray@aquaq.co.uk KOD #4160315

q).req.get["http://httpbin.org/get";()!()];
-- REQUEST --
GET /get HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 200 OK
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:35:50 GMT
Content-Type: application/json
Content-Length: 162
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

{"args":{},"headers":{"Accept":"*/*","Connection":"close","Host":"httpbin.org","User-Agent":"kdb+/3.5"},"origin":"146.199.80.196","url":"http://httpbin.org/get"}
```

An example including [HTTP redirects](../features/redirects.md) i.e. multiple requests & responses, and setting `.req.VERBOSE:1b` within q session:

```
jonny@kodiak ~/reQ (master) $ q req.q
KDB+ 3.5 2018.04.25 Copyright (C) 1993-2018 Kx Systems
l64/ 4(16)core 7360MB jonny kodiak 127.0.1.1 EXPIRE 2019.05.21 jonathon.mcmurray@aquaq.co.uk KOD #4160315

q).req.VERBOSE:1b
q).req.get["http://httpbin.org/redirect/2";()!()];
-- REQUEST --
GET /redirect/2 HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 302 FOUND
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:36:32 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 247
Location: /relative-redirect/1
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to target URL: <a href="/relative-redirect/1">/relative-redirect/1</a>.  If not click the link.
-- REQUEST --
GET /relative-redirect/1 HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 302 FOUND
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:36:32 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 0
Location: /get
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur


-- REQUEST --
GET /get HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 200 OK
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:36:32 GMT
Content-Type: application/json
Content-Length: 162
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

{"args":{},"headers":{"Accept":"*/*","Connection":"close","Host":"httpbin.org","User-Agent":"kdb+/3.5"},"origin":"146.199.80.196","url":"http://httpbin.org/get"}
```