# HTTP Request Headers

---

## Default headers

The default headers sent with requests are found in `.req.def`:

```
q).req.def
"Connection"| "Close"
"User-Agent"| "kdb+/3.5"
"Accept"    | "*/*"
```

The `User-Agent` header is automatically generated from the version of kdb+
(i.e. `.z.K`)

## Custom headers

One of the key features of reQ is the ability to send custom headers with HTTP
requests. This is done by supplying a dictionary of custom headers as the
second argument to many of the [User API](../api/md/public.md) functions, such as
[`.req.get`](../api/md/public.md#reqget), [`.req.post`](../api/md/public.md#reqpost),
[`.req.delete`](../api/md/public.md#reqdelete) and [`.req.del`](../api/md/public.md#reqdel)

For example:

```
q).req.get["http://httpbin.org/headers";`custom`headers!("with custom";"values")]
       | Accept Connection Custom        Headers  Host          User-Agent
-------| -----------------------------------------------------------------
headers| "*/*"  "close"    "with custom" "values" "httpbin.org" "kdb+/3.5"
```