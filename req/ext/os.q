/ os.q taken from https://github.com/jonathonmcmurray/qutil_packages @ beaabdd

\d .os

es:$[.z.o like "w*";" 2>NUL";" 2>/dev/null"];                                       //error suppression dependent on os
test:{[x]
  /* .os.test - test if a command works on current os */
  :@[{system x;1b};x,es;0b];                                                        //run with system & suppress error
  }

home:hsym`$getenv$[.z.o like "w*";`USERPROFILE;`HOME]                               //get home dir depending on OS
hfile:(` sv home,)                                                                  //get file path relative to home dir

read:{$[1=count a;first;]a:read0 x}                                                 //read text file, single string if one line
write:{x 0:$[10=type y;enlist;]y}                                                   //write text file, list of strings or single

hread:{read hfile x}                                                                //read file from home dir
hwrite:{write[hfile x;y]}                                                           //write file in home dir

\d .

