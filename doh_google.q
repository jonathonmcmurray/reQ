\d .doh

ENABLED:1b;                                                                         //enable by default
url:"dns.google.com";                                                               //URL for API
cache:()!()                                                                         //cache IP for URL

cache[`$url]:url;                                                                   //don't resolve the resolver

resolve:{[url]
  /* take a URL, resolve URL to IP & return */
  if[(`$h:.req.host[url]) in key cache;
     :.req.prot[url],u,((not ""~u:.req.user url)#"@"),cache[`$h],.req.endp[url]];   //return from cache if present
  r:.j.k .req.get["https://dns.google.com/resolve?name=",h;()!()];                  //request from Google API
  i:first r[`Answer][`data];                                                        //get first record
  cache[`$h]:i;                                                                     //cache resovled IP
  :.req.prot[url],u,((not ""~u:.req.user url)#"@"),i,.req.endp[url];                //return resolved URL
 }

\d .
