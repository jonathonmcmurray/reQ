# HTTP redirects

---

reQ will automatically follow redirects, both absolute & relative. For example,

## Relative redirect example
```
q).req.get["http://httpbin.org/relative-redirect/2";()!()];
-- REQUEST --
GET /relative-redirect/2 HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 302 FOUND
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:41:53 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 0
Location: /relative-redirect/1
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur


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
Date: Mon, 04 Jun 2018 22:41:54 GMT
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
Date: Mon, 04 Jun 2018 22:41:54 GMT
Content-Type: application/json
Content-Length: 162
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

{"args":{},"headers":{"Accept":"*/*","Connection":"close","Host":"httpbin.org","User-Agent":"kdb+/3.5"},"origin":"146.199.80.196","url":"http://httpbin.org/get"}
```

## Absolute redirect example

```
q).req.get["http://httpbin.org/absolute-redirect/2";()!()];
-- REQUEST --
GET /absolute-redirect/2 HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 302 FOUND
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:42:02 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 283
Location: http://httpbin.org/absolute-redirect/1
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to target URL: <a href="http://httpbin.org/absolute-redirect/1">http://httpbin.org/absolute-redirect/1</a>.  If not click the link.
-- REQUEST --
GET /absolute-redirect/1 HTTP/1.1
Host: httpbin.org
Connection: Close
User-Agent: kdb+/3.5
Accept: */*


-- RESPONSE --
HTTP/1.1 302 FOUND
Connection: close
Server: gunicorn/19.8.1
Date: Mon, 04 Jun 2018 22:42:02 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 251
Location: http://httpbin.org/get
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>Redirecting...</h1>
<p>You should be redirected automatically to target URL: <a href="http://httpbin.org/get">http://httpbin.org/get</a>.  If not click the link.
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
Date: Mon, 04 Jun 2018 22:42:03 GMT
Content-Type: application/json
Content-Length: 162
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur

{"args":{},"headers":{"Accept":"*/*","Connection":"close","Host":"httpbin.org","User-Agent":"kdb+/3.5"},"origin":"146.199.80.196","url":"http://httpbin.org/get"}
```
