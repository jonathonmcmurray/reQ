\d .doh

ENABLED:1b;                                                                         //enable by default
url:"dns.google.com";                                                               //URL for API
cache:()!()                                                                         //cache IP for URL

cache[`$url]:url;                                                                   //don't resolve the resolver

resolve:{[url]
  /* take a URL, resolve URL to IP & return */
  uo:.url.parse0[0b;url];                                                           //parse to object
  if[(`$h:uo`host) in key cache;
     :.url.format @[uo;`host;:;cache`$h];                                           //return from cache if present
    ];
  r:.j.k .req.get["https://dns.google.com/resolve?name=",h;()!()];                  //request from Google API
  i:first r[`Answer][`data];                                                        //get first record
  cache[`$h]:i;                                                                     //cache resovled IP
  :.url.format @[uo;`host;:;i];                                                     //return resolved URL
  }

\d .

