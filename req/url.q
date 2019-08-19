\d .url

// @kind function
// @category private
// @fileoverview Parse URL query; split on ?, urldecode query
// @param x {string} URL containing query
// @return {(string;dict)} (URL;parsed query)
query:{[x]@["?"vs x;1;dec]}                                                         //split on ?, urldecode query

// @kind function
// @category private
// @fileoverview parse a string/symbol/hsym URL into a URL dictionary
// @param q {boolean} parse URL query to kdb dict
// @param x {string|symbol|#hsym} URL containing query
// @return {dict} URL dictionary
parse0:{[q;x]
  if[x~hsym`$255#"a";'"hsym too long - consider using a string"];                   //error if URL~`: .. too long
  x:sturl x;                                                                        //ensure string URL
  p:x til pn:3+first ss[x;"://"];                                                   //protocol
  uf:("@"in x)&first[ss[x;"@"]]<first ss[pn _ x;"/"];                               //user flag - true if username present
  un:pn;                                                                            //default to no user:pass
  u:-1_$[uf;(pn _ x) til (un:1+first ss[x;"@"])-pn;""];                             //user:pass
  d:x til dn:count[x]^first ss[x:un _ x;"/"];                                       //domain
  a:$[dn=count x;enlist"/";dn _ x];                                                 //absolute path
  o:`protocol`auth`host`path!(p;u;d;a);                                             //create URL object
  :$[q;@[o;`path`query;:;query o`path];o];                                          //split path into path & query if flag set, return
  }

// @kind function
// @category private
// @fileoverview parse a string/symbol/hsym URL into a URL dictionary & parse query
// @param x {string|symbol|#hsym} URL containing query
// @return {dict} URL dictionary
// @qlintsuppress RESERVED_NAME
.url.parse:parse0[1b]                                                               //projection to parse query by default

// @kind function
// @category private
// @fileoverview format URL object into string
// @param x {dict} URL dictionary
// @return {string} URL
format:{[x]
  :raze[x`protocol`auth],$[count x`auth;"@";""],                                    //protocol & if present auth (with @)
  x[`host],$[count x`path;x`path;"/"],                                              //host & path
  $[99=type x`query;"?",enc x`query;""];                                            //if there's a query, encode & append
  }

// @kind function
// @category private
// @fileoverview return URL as a string
// @param x {string|symbol|#hsym} URL
// @return {string} URL
sturl:{(":"=first x)_x:$[-11=type x;string;]x}

// @kind function
// @category private
// @fileoverview return URL as an hsym
// @param x {string|symbol|#hsym} URL
// @return {#hsym} URL
hsurl:{`$":",sturl x}

// @kind function
// @category private
// @fileoverview URI escaping for non-safe chars, RFC-3986
// @param x {string} URL
// @return {string} URL
hu:.h.hug .Q.an,"-.~"

// @kind function
// @category private
// @fileoverview encode a KDB dictionary as a URL encoded string
// @param d {dict} kdb dictionary to encode
// @return {string} URL encoded string
enc:{[d]
  k:key d;v:value d;                                                                //split dictionary into keys & values
  v:enlist each .url.hu each {$[10=type x;x;string x]}'[v];                         //string any values that aren't stringed,escape any chars that need it
  k:enlist each $[all 10=type each k;k;string k];                                   //if keys are strings, string them
  :"&" sv "=" sv' k,'v;                                                             //return urlencoded form of dictionary
  }

// @kind function
// @category private
// @fileoverview decode a URL encoded string to a KDB dictionary
// @param x {string} URL encoded string
// @return {dict} kdb dictionary to encode
dec:{[x]
  :(!/)"S=&"0:.h.uh ssr[x;"+";" "];                                                 //parse incoming request into dict, replace escaped chars
  }
