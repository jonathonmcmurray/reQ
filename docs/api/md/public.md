

## .auth.cache

 storage for basic auth credential cache

## .auth.netrcenabled

 boolean flag to determine whether to use ~/.netrc by default

## .auth.netrclocation

 location of .netrc file, by default ~/.netrc

## .b64.dec

 base64 decode a string

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|base64 string to be decoded|

**Returns:**

|Type|Description|
|---|---|
|string|decoded string|

## .b64.enc

 base64 encode a string. Where available, defaults to .Q.btoa built-in

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|string to be encoded|

**Returns:**

|Type|Description|
|---|---|
|string|encoded string|

## .cookie.addcookie

 Add or update a cookie in the jar

**Parameters:**

|Name|Type|Description|
|---|---|---|
|h|string|hostname on which to apply cookie|
|c|string|cookie string|

**Returns:**

|Type|Description|
|---|---|
|null||

## .cookie.jar

 storage for cookies

## .cookie.readjar

 Read a Netscape/cURL format cookiejar

**Parameter:**

|Name|Type|Description|
|---|---|---|
|f|string \| symbol \| hsym|filename |

**Returns:**

|Type|Description|
|---|---|
|table|cookie jar|

## .cookie.writejar

 Write a Netscape/cURL format cookiejar

**Parameters:**

|Name|Type|Description|
|---|---|---|
|f|string \| symbol \| hsym|filename |
|j|table|cookie jar|

**Returns:**

|Type|Description|
|---|---|
|hsym|cookie jar filename |

## .req.del

 Send an HTTP DELETE request, no body

**Parameters:**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|

**Returns:**

|Type|Description|
|---|---|
|(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.delete

 Send an HTTP DELETE request

**Parameters:**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|
|z|string|body for HTTP request|

**Returns:**

|Type|Description|
|---|---|
|(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.g

 Send an HTTP GET request (simple, no custom headers)

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |

**Returns:**

|Type|Description|
|---|---|
|(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.get

 Send an HTTP GET request

**Parameters:**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|

**Returns:**

|Type|Description|
|---|---|
|(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.post

 Send an HTTP POST request

**Parameters:**

|Name|Type|Description|
|---|---|---|
|x|symbol \| string \| hsym|URL |
|y|dict|dictionary of custom HTTP headers to use|
|z|string|body for HTTP request|

**Returns:**

|Type|Description|
|---|---|
|(dict; string) \| any|HTTP response (headers;body), or parsed if JSON|

## .req.send

 Send an HTTP request

**Parameters:**

|Name|Type|Description|
|---|---|---|
|m|symbol|HTTP method/verb|
|u|symbol \| string \| hsym|URL |
|hd|dict|dictionary of custom HTTP headers to use|
|p|string|payload/body (for POST requests)|
|v|boolean|verbose flag|

**Returns:**

|Type|Description|
|---|---|
|(dict; string)|HTTP response (headers;body)|



## .req.timeout

 *EXPERIMENTAL* send a request with a client-side timeout

**Parameters:**

|Name|Type|Description|
|---|---|---|
|t|int \| long|timeout (seconds)|
|m|symbol|HTTP method/verb|
|u|symbol \| string \| hsym|URL |
|hd|dict|dictionary of custom HTTP headers to use|
|p|string|payload/body (for POST requests)|

**Returns:**

|Type|Description|
|---|---|
|(dict; string)|HTTP response (headers;body)|
