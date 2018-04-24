/JIRA example for reQ library

/ load reQ library
\l req.q
/ load util funcs for examples
\l examples/util.q

\d .jira

cfg:.utl.cfg`jira                                                                   //get config details
int:.z.f like "*jira.q";                                                            //check if jira.q on cmd line - if not, library funcs
url:.req.prot[cfg`url],cfg[`user],"@",.req.host[cfg`url],"/rest/api/2/";            //base URL to use

createissue:{[project;summary;description;issuetype;reporter;assignee;labels]
  d:enlist[`]!enlist(::);                                                           //create null key to prevent casting type of dict
  d[`project]:enlist[`key]!enlist project;                                          //add project key
  d[`summary]:summary;                                                              //title of issue
  d[`issuetype]:enlist[`name]!enlist issuetype;                                     //type by name (`Task `Bug etc.)
  d[`assignee]:enlist[`name]!enlist assignee;                                       //username to assign to
  d[`reporter]:enlist[`name]!enlist reporter;                                       //username reporting
  d[`description]:description;                                                      //body of issue
  d[`labels]:labels;                                                                //labels
  d:enlist[`]_d;                                                                    //remove null key
  d:enlist[`fields]!enlist d;                                                       //create JIRA data structure
  r:.req.post[url,"issue";enlist["Content-Type"]!enlist .req.ty`json;.j.j d];       //send POST request
  :r`self;                                                                          //return API URL for created issue
 }

getprojects:{[]
  :`name`key`id#.req.get[url,"project";()!()];                                      //get projects available in JIRA
 }

\d .