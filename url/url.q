\d .url

query:{[x]@["?"vs x;1;urldecode]}                                                   //split on ?, urldecode query

parse0:{[q;x] /q-parse query,x-URL
  /* parse a string/symbol/hsym URL into a URL dictionary */
  if[x~hsym`$255#"a";'"hsym too long - consider using a string"];                   //error if URL~`: .. too long
  x:sturl x;                                                                        //ensure string URL
  p:x til pn:3+first ss[x;"://"];                                                   //protocol
  uf:("@"in x)&first[ss[x;"@"]]<first ss[pn _ x;"/"];                               //user flag - true if username present
  u:-1_$[uf;(pn _ x) til (un:1+first ss[x;"@"])-pn;""];                             //user:pass
  if[u~"";un:pn];                                                                   //if no user:pass, look for domain after protocol
  d:x til dn:count[x]^first ss[x:un _ x;"/"];                                       //domain
  a:$[dn=count x;enlist"/";dn _ x];                                                 //absolute path
  o:`protocol`auth`host`path!(p;u;d;a);                                             //create URL object
  :$[q;@[o;`path`query;:;query o`path];o];                                          //split path into path & query if flag set, return
 }
.url.parse:parse0[1b]                                                               //projection to parse query by default

format:{[x]
  /* format URL object into string */
  :raze[x`protocol`auth],$[count x`auth;"@";""],                                    //protocol & if present auth (with @)
  x[`host],$[count x`path;x`path;"/"],                                              //host & path
  $[99=type x`query;"?",urlencode x`query;""];                                      //if there's a query, encode & append
 }

sturl:{(":"=first x)_x:$[-11=type x;string;]x}                                      //convert URL to string
hsurl:{`$":",sturl x}                                                               //convert URL to hsym
hu:.h.hug .Q.an,"-.~"                                                               //URI escaping for non-safe chars, RFC-3986

urlencode:{[d] /d-dictionary
  /* encode a KDB dictionary as a URL encoded string */
  k:key d;v:value d;                                                                //split dictionary into keys & values
  v:enlist each hu each {$[10=type x;x;string x]}'[v];                              //string any values that aren't stringed,escape any chars that need it
  k:enlist each $[all 10=type each k;k;string k];                                   //if keys are strings, string them
  :"&" sv "=" sv' k,'v;                                                             //return urlencoded form of dictionary
 }

urldecode:{[x] /x-urlencoded string
  /* convert a URL encoded string to a KDB dictionary */
  :(!/)"S=&"0:.h.uh ssr[x;"+";" "];                                                 //parse incoming request into dict, replace escaped chars
 }
