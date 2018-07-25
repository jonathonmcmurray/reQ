/GitHub example for reQ library

/ load reQ library
\l req.q
/ load util funcs for examples
\l examples/util.q

\d .gh

cfg:.utl.cfg`github                                                                 //get config details
int:.z.f like "*github.q";                                                          //check if github.q on cmd line - if not, library funcs
url:"https://api.github.com/"                                                       //basic URL

repo:{[u;r]
  r:.req.get[url,"repos/",u,"/",r;enlist[`Authorization]!enlist"token ",cfg`token]; //get repo
  r:`name`owner`html_url`description`size`stargazers_count`watchers_count#r;        //take summary info
  :@[r;`owner;@[;`login]];                                                          //return summary of repo details
 }

createissue:{[u;r;title;body;labels]
  ul:url,"repos/",u,"/",r,"/issues";                                                //build URL
  hd:("Authorization";"Content_Type")!("token ",cfg`token;.req.ty`json);            //build HTTP headers
  labels:$[-11=t:type labels;(),labels;10=t;enlist labels;labels];                  //ensure list of syms/strings
  d:`title`body`labels!(title;body;labels);                                         //build input object
  r:.req.post[ul;hd;.j.j d];                                                        //perform API request
  :r`html_url;                                                                      //return URL of new issue
 }

user:{[u] .req.g url,"users/",u}
orgs:{[u] .req.g url,"users/",u,"/orgs"}

\d .

if[.gh.int&first .z.x[0] like "*/*";
   show .gh.repo . "/" vs .z.x 0;
   exit 0;
  ];

if[.gh.int;
   show .gh.repo . 2#.z.x;
   exit 0;
  ];
