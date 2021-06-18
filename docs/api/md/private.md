

## .auth.getauth

*EXPERIMENTAL* prompt for authorization if requested

**Parameters:**

|Name|Type|Description|
|---|---|---|
|h|dict|HTTP response headers|
|u|string \| symbol \| hsym|URL File symbol|

**Returns:**

|Type|Description|
|---|---|
|string|updated URL with supplied credentials|

## .auth.getcache

get cached auth string for a given host

**Parameter:**

|Name|Type|Description|
|---|---|---|
|hst|string|hostname|

**Returns:**

|Type|Description|
|---|---|
|string|cached auth string|

## .auth.readnetrc

retrieve login from .netrc file

**Parameter:**

|Name|Type|Description|
|---|---|---|
|host|string|hostname to get login for|

**Returns:**

|Type|Description|
|---|---|
|string|auth string in format "user:pass"|

## .auth.setcache

cache auth string for a given host

**Parameters:**

|Name|Type|Description|
|---|---|---|
|host|string|hostname|
|auth|string|auth string in format "user:pass"|

**Returns:**

|Type|Description|
|---|---|
||null|

## .cookie.addcookies

Add stored cookie(s) relevant to current query

**Parameter:**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Type|Description|
|---|---|
|dict|query objeect with added cookies|

## .cookie.getcookies

Get stored cookie(s) relevant to current query

**Parameter:**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Type|Description|
|---|---|
|string|cookie(s)|

## .req.addheaders

Convert headers to strings & add authorization and Content-Length

**Parameter:**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Type|Description|
|---|---|
|dict|Updated query object|

## .req.buildquery

Construct full HTTP query string from query object

**Parameter:**

|Name|Type|Description|
|---|---|---|
|q|dict|query object|

**Returns:**

|Type|Description|
|---|---|
|string|HTTP query string|

## .req.enchd

Convert a KDB dictionary into HTTP headers

**Parameter:**

|Name|Type|Description|
|---|---|---|
|d|dict|dictionary of headers|

**Returns:**

|Type|Description|
|---|---|
|string|string HTTP headers|

## .req.formatresp

Split HTTP response into headers & dict

**Parameter:**

|Name|Type|Description|
|---|---|---|
|r|string|raw HTTP response|

**Returns:**

|Type|Description|
|---|---|
|(dict; string; string)|(response header;response body;raw headers)|

## .req.gb

Generate boundary marker

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|any|Unused|

**Returns:**

|Type|Description|
|---|---|
|string|Boundary marker|

## .req.mkpt

Create one part for a multipart form

**Parameters:**

|Name|Type|Description|
|---|---|---|
|b|string|boundary marker|
|n|string|name for form part|
|v|string|value for form part|

**Returns:**

|Type|Description|
|---|---|
|string[]|multipart form|

## .req.mult

Build multi-part object

**Parameters:**

|Name|Type|Description|
|---|---|---|
|b|string|boundary marker|
|d|dict|headers (incl. file to be multiparted)|

**Returns:**

|Type|Description|
|---|---|
|string|Multipart form|

## .req.multi

Convert a q dictionary to a multipart form

**Parameter:**

|Name|Type|Description|
|---|---|---|
|d|dict|kdb dictionary to convert to form|

**Returns:**

|Type|Description|
|---|---|
|(dict; string)|(HTTP headers;body) to give to .req.post|

## .req.okstatus

Signal if not OK status, return unchanged response if OK

**Parameters:**

|Name|Type|Description|
|---|---|---|
|v|boolean|verbose flag|
|x|(dict; string)|HTTP response object|

**Returns:**

|Type|Description|
|---|---|
|(dict; string)|HTTP response object|

## .req.parseresp

Parse to kdb object based on Content-Type header. Only supports JSON currently

**Parameter:**

|Name|Type|Description|
|---|---|---|
|r|(dict; string)|HTTP respone|

**Returns:**

|Type|Description|
|---|---|
|any|Parsed response|

## .req.proxy

Applies proxy if relevant

**Parameter:**

|Name|Type|Description|
|---|---|---|
|u|dict|URL object|

**Returns:**

|Type|Description|
|---|---|
|dict|Updated URL object|

## .status.class

get status "class" from status code, header dict or return object

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|int \| dict \| (dict; string)|status code, header dict or return object|

**Returns:**

|Type|Description|
|---|---|
|int|status class|

## .url.dec

decode a URL encoded string to a KDB dictionary

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|URL encoded string|

**Returns:**

|Type|Description|
|---|---|
|dict|kdb dictionary to encode|

## .url.enc

encode a KDB dictionary as a URL encoded string

**Parameter:**

|Name|Type|Description|
|---|---|---|
|d|dict|kdb dictionary to encode|

**Returns:**

|Type|Description|
|---|---|
|string|URL encoded string|

## .url.format

format URL object into string

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|dict|URL dictionary|

**Returns:**

|Type|Description|
|---|---|
|string|URL|

## .url.hsurl

return URL as an hsym

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL File symbol|

**Returns:**

|Type|Description|
|---|---|
|hsym|URL File symbol|

## .url.hu

URI escaping for non-safe chars, RFC-3986

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|URL|

**Returns:**

|Type|Description|
|---|---|
|string|URL|

## .url.parse

parse a string/symbol/hsym URL into a URL dictionary & parse query

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL containing query File symbol|

**Returns:**

|Type|Description|
|---|---|
|dict|URL dictionary|

## .url.parse0

parse a string/symbol/hsym URL into a URL dictionary

**Parameters:**

|Name|Type|Description|
|---|---|---|
|q|boolean|parse URL query to kdb dict|
|x|string \| symbol \| hsym|URL containing query File symbol|

**Returns:**

|Type|Description|
|---|---|
|dict|URL dictionary|

## .url.query

Parse URL query; split on ?, urldecode query

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|URL containing query|

**Returns:**

|Type|Description|
|---|---|
|(string; dict)|(URL;parsed query)|

## .url.sturl

return URL as a string

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string \| symbol \| hsym|URL File symbol|

**Returns:**

|Type|Description|
|---|---|
|string|URL|
