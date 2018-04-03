/Advent of Code example for reQ library
/Retrieve a private leaderboard or download daily challenge input

/ load reQ library
\l req.q
/ load util funcs for examples
\l examples/util.q

\d .aoc

cfg:.utl.cfg`aoc                                                                    //get config details
opts:.Q.def[`year`day`o!(`year$.z.D;`dd$.z.D;`$first system"pwd")] .Q.opt .z.x;     //get cmd line params
opts:string each opts;                                                              //string params
int:.z.f like "*aoc.q";                                                             //check if aoc.q on cmd line - if not, library funcs

board:{[y;b]
  /* get a leaderboard for a given year */
  r:.req.get["http://adventofcode.com/",y,"/leaderboard/private/view/",b,".json";   //request board
            enlist[`Cookie]!enlist"session=",cfg`session];                          //add session cookie as HTTP header
  r:`name`local_score`stars`global_score`id`last_star_ts#/:value r`members;         //pull out relevant fields
  :`local_score xdesc update name:("anon",/:id) from r where 10h<>type each name;   //fix anon users, sort
 }

day:{[y;d;o]
  /* get challenge input for a given day & save locally */
  -1"Downloading input for ",y," day ",d," to: ",string o;                          //log day being dowloaded & output file
  r:.req.get["http://adventofcode.com/",y,"/day/",d,"/input";                       //download input
            enlist[`Cookie]!enlist"session=",cfg`session];                          //add session cookie as HTTP header
  o 0: -1_"\n" vs r;                                                                //write to file
 }

\d .

/ get leaderboard if requested
if[.aoc.int&`board in key .aoc.opts;                                                //do nothing if loaded as lib
   show .aoc.board . .aoc.opts`year`board;
   exit 0;
  ];

/ otherwise download challenge input if aoc.q on cmd line
if[.aoc.int;                                                                        //do nothing if loaded as lib
   f:` sv hsym[`$.aoc.opts`o],`$"p",.aoc.opts`day;
   .aoc.day[.aoc.opts`year;.aoc.opts`day;f];
   exit 0;
  ]
