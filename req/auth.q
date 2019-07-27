\d .auth

getauth:{[h;u] /h-headers,u-URL
  /* prompt for user & pass when site requests basic auth */
  h:upper[key h]!value h;                                                           //upper case header names
  if[not h[`$"WWW-AUTHENTICATE"] like "Basic *";'"unsupported auth challenge"];     //check it needs basic auth
  -1"Site requested basic auth\nWARNING: user & pass will show in plain text\n";    //warn user before they type pass
  1"User: ";s:read0 0;                                                              //get username
  1"Pass: ";p:read0 0;                                                              //get password
  :.url.format @[.url.parse0[0b] u;`auth;:;s,":",p];                                //update URL with supplied username & pass
 }

\d .