\d .auth

// @kind function
// @category private
// @fileoverview *EXPERIMENTAL* prompt for authorization if requested
// @param h {dict} HTTP response headers
// @param u {string|symbol|#hsym} URL
// @return {string} updated URL with supplied credentials
getauth:{[h;u] /h-headers,u-URL
  /* prompt for user & pass when site requests basic auth */
  h:upper[key h]!value h;                                                           //upper case header names
  if[not h[`$"WWW-AUTHENTICATE"] like "Basic *";'"unsupported auth challenge"];     //check it needs basic auth
  -1"Site requested basic auth\nWARNING: user & pass will show in plain text\n";    //warn user before they type pass
  1"User: ";s:read0 0;                                                              //get username
  1"Pass: ";p:read0 0;                                                              //get password
  :.url.format @[.url.parse0[0b] u;`auth;:;s,":",p];                                //update URL with supplied username & pass
  }

cache:([host:`$()]auth:();expires:`timestamp$())
setcache:{[host;auth]cache[`$host]:`auth`expires!(auth;.z.p+0D00:15:00)}
getcache:{[hst]exec first auth from cache where host=`$hst,expires>.z.p}

\d .

