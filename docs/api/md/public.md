

## .b64.dec

 base64 decode a string

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string|base64 string to be decoded|

**Returns:**

|Name|Type|Description|
|---|---|---|
||sting|decoded string|

## .b64.enc

 base64 encode a string

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string|string to be encoded|

**Returns:**

|Name|Type|Description|
|---|---|---|
||sting|encoded string|

## .cookie.addcookie

 Add or update a cookie in the jar

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|h|string|hostname on which to apply cookie|
|c|string|cookie string|

**Returns:**

|Name|Type|Description|
|---|---|---|
||null||

## .cookie.jar

 storage for cookies

## .cookie.readjar

 Read a Netscape/cURL format cookiejar

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|f|string \| symbol \| hsym|filename |

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|table|cookie jar|

## .req.d

 Send an HTTP DELETE request,no body or custom headers

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.del

 Send an HTTP DELETE request, no body

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.delete

 Send an HTTP DELETE request

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|
|z|string|body for HTTP request|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.g

 Send an HTTP GET request (simple, no custom headers)

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.get

 Send an HTTP GET request

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.post

 Send an HTTP POST request

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|
|z|string|body for HTTP request|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.send

 Send an HTTP request

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|m|symbol|HTTP method/verb|
|u|symbol \| string \| hsym|URL |
|hd|dict|dictionary of custom HTTP headers to use|
|p|string|payload/body (for POST requests)|
|v|boolean|verbose flag|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string)|HTTP response (headers;body)|



## .req.timeout

 *EXPERIMENTAL* send a request with a client-side timeout

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|t|int \| long|timeout (seconds)|
|m|symbol|HTTP method/verb|
|u|symbol \| string \| hsym|URL |
|hd|dict|dictionary of custom HTTP headers to use|
|p|string|payload/body (for POST requests)|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string)|HTTP response (headers;body)|
