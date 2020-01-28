

## .auth.getauth

 *EXPERIMENTAL* prompt for authorization if requested

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|h|dict|HTTP response headers|
|u|string \| symbol \| hsym|URL |

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|updated URL with supplied credentials|

## .auth.getcache

 get cached auth string for a given host

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|hst|string|hostname|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|cached auth string|

## .auth.readnetrc

 retrieve login from .netrc file

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|host|string|hostname to get login for|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|auth string in format "user:pass"|

## .auth.setcache

 cache auth string for a given host

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|host|string|hostname|
|auth|string|auth string in format "user:pass"|

**Returns:**

|Name|Type|Description|
|---|---|---|
|||null|

## .cookie.addcookies

 Add stored cookie(s) relevant to current query

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|query objeect with added cookies|

## .cookie.getcookies

 Get stored cookie(s) relevant to current query

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|cookie(s)|

## .req.addheaders

 Convert headers to strings & add authorization and Content-Length

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|Updated query object|

## .req.buildquery

 Construct full HTTP query string from query object

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|HTTP query string|

## .req.enchd

 Convert a KDB dictionary into HTTP headers

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|d|dict|dictionary of headers|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|string HTTP headers|

## .req.formatresp

 Split HTTP response into headers & dict

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|r|string|raw HTTP response|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string)|(response header;response body)|

## .req.gb

 Generate boundary marker

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|any|Unused|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|Boundary marker|

## .req.mkpt

 Create one part for a multipart form

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|b|string|boundary marker|
|n|string|name for form part|
|v|string|value for form part|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string[]|multipart form|

## .req.mult

 Build multi-part object

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|b|string|boundary marker|
|d|dict|headers (incl. file to be multiparted)|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|Multipart form|

## .req.multi

 Convert a q dictionary to a multipart form

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|d|dict|kdb dictionary to convert to form|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string)|(HTTP headers;body) to give to .req.post|

## .req.okstatus

 Signal if not OK status, return unchanged response if OK

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|v|boolean|verbose flag|
|x|(dict; string)|HTTP response object|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(dict; string)|HTTP response object|

## .req.parseresp

 Parse to kdb object based on Content-Type header. Only supports JSON currently

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|r|(dict; string)|HTTP respone|

**Returns:**

|Name|Type|Description|
|---|---|---|
||any|Parsed response|

## .req.proxy

 Applies proxy if relevant

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|u|dict|URL object|

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|Updated URL object|

## .status.class

 get status "class" from status code, header dict or return object

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|int \| dict \| (dict; string)|status code, header dict or return object|

**Returns:**

|Name|Type|Description|
|---|---|---|
||int|status class|

## .url.dec

 decode a URL encoded string to a KDB dictionary

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string|URL encoded string|

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|kdb dictionary to encode|

## .url.enc

 encode a KDB dictionary as a URL encoded string

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|d|dict|kdb dictionary to encode|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|URL encoded string|

## .url.format

 format URL object into string

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|dict|URL dictionary|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|URL|

## .url.hsurl

 return URL as an hsym

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL |

**Returns:**

|Name|Type|Description|
|---|---|---|
||hsym|URL |

## .url.hu

 URI escaping for non-safe chars, RFC-3986

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string|URL|

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|URL|

## .url.parse

 parse a string/symbol/hsym URL into a URL dictionary & parse query

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL containing query |

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|URL dictionary|

## .url.parse0

 parse a string/symbol/hsym URL into a URL dictionary

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|q|boolean|parse URL query to kdb dict|
|x|string \| symbol \| hsym|URL containing query |

**Returns:**

|Name|Type|Description|
|---|---|---|
|&lt;returns&gt;|dict|URL dictionary|

## .url.query

 Parse URL query; split on ?, urldecode query

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string|URL containing query|

**Returns:**

|Name|Type|Description|
|---|---|---|
||(string; dict)|(URL;parsed query)|

## .url.sturl

 return URL as a string

**Parameter(s):**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL |

**Returns:**

|Name|Type|Description|
|---|---|---|
||string|URL|
