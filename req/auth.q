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
  if[not h[`$"www-authenticate"] like "Basic *";'"unsupported auth challenge"];     //check it needs basic auth
  -1"Site requested basic auth\nWARNING: user & pass will show in plain text\n";    //warn user before they type pass
  1"User: ";s:read0 0;                                                              //get username
  1"Pass: ";p:read0 0;                                                              //get password
  :.url.format @[.url.parse0[0b] u;`auth;:;s,":",p];                                //update URL with supplied username & pass
  }

// @kind data
// @category public
// @fileoverview storage for basic auth credential cache
cache:([host:`$()]auth:();expires:`timestamp$())

// @kind function
// @category private
// @fileoverview cache auth string for a given host
// @param host {string} hostname
// @param auth {string} auth string in format "user:pass"
// @return null
setcache:{[host;auth]cache[`$host]:`auth`expires!(auth;.z.p+0D00:15:00)}

// @kind function
// @category private
// @fileoverview get cached auth string for a given host
// @param hst {string} hostname
// @return {string} cached auth string
getcache:{[hst]
  r:exec first auth from cache where host=`$hst,expires>.z.p;
  if[count r;:r];
  if[netrcenabled;:readnetrc hst];
  :();
 }

// @kind data
// @category public
// @fileoverview boolean flag to determine whether to use ~/.netrc by default
netrcenabled:not()~key .os.hfile`.netrc

// @kind data
// @category public
// @fileoverview location of .netrc file, by default ~/.netrc
netrclocation:.os.hfile`.netrc

// @kind function
// @category private
// @fileoverview retrieve login from .netrc file
// @param host {string} hostname to get login for
// @return {string} auth string in format "user:pass"
readnetrc:{[host]
  i:.os.read netrclocation;
  t:(uj/){enlist(!/)"S*"$flip x} each (where i like "machine *") cut " " vs/:i;
  if[0=count t:select from t where machine like host;:()];
  :":"sv first[t]`login`password;
 }

\d .

