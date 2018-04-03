# reQ Examples

#### Index

* [Advent of Code](#advent-of-code-aocq)
* [GitHub](#github-githubq)

Within this directory are a number of examples of usage for the reQ library. 
Each example consists of a Q script, which can function standalone or as a 
library loaded within other Q scripts. There is also a `.cfg` file for each
example containing various configuration details (e.g. authorisation token,
session cookie etc.).

Also present is a script named `util.q` consisting of any small utilities used
throughout the examples (e.g. for loading config file etc.).

While each script can be used as a "library" for the given service, it may be
necessary to modify these slightly in order to ensure file paths are correct
etc. depending on the layout of your code.

Also note that there is minimal/no error checking & handling in these scripts in
order to maintain simplicity - this should be added as required when using any
of this code in your own scripts.

### Config files

The config files are simple key-value pairs like so:

```
key1=value1
key2=value2
```

It should be simple and straightforward to modify these as required.

## Advent of Code (`aoc.q`)

This script provides functions for accessing the [Advent of
Code](http://adventofcode.com/) website. Two functions are provided, one for the
retrieval of a private leaderboard, and another for the retrieval of the
challenge input for a given day.

In order to use the script standalone, a number of command line args can be
supplied:

* `board` - the ID of a private leaderboard to display [no default]
* `year` - year to get board/input for [default: this year]
* `day` - day to get input for [default: today]
* `o` - output directory [default: working dir]

If `-board` is supplied, the board will be downloaded & shown, otherwise, a
challenge input will be downloaded & saved (using defaults if no overwrites
provided)

The only config value required for this example is your session cookie (you
should be able to retrieve this value by logging in with your browser and
checking in browser settings, generally the cookie is valid for ~30 days)

```
$ q examples/aoc.q -board 113948 -year 2017
KDB+ 3.5 2017.11.30 Copyright (C) 1993-2017 Kx Systems
l64/ 8()core 16048MB jmcmurray homer.aquaq.co.uk 127.0.1.1 EXPIRE 2018.06.30
AquaQ #50170

name     local_score stars global_score id       last_star_ts
---------------------------------------------------------------------------
"anon0"  1200        50    364          "113948" "2017-12-25T00:17:26-0500"
"anon1"  1137        50    0            "19600"  "2017-12-25T03:14:13-0500"
"anon2"  1020        50    0            "125388" "2017-12-26T07:50:23-0500"
"anon3"  907         47    0            "113960" "2017-12-24T05:32:49-0500"
"anon4"  827         45    0            "125198" "2018-01-03T10:11:01-0500"
"anon5"  759         39    0            "113940" "2017-12-20T05:57:05-0500"
"anon6"  687         37    0            "125819" "2017-12-27T06:08:22-0500"

$ q examples/aoc.q -year 2017 -day 16
KDB+ 3.5 2017.11.30 Copyright (C) 1993-2017 Kx Systems
l64/ 8()core 16048MB jmcmurray homer.aquaq.co.uk 127.0.1.1 EXPIRE 2018.06.30
AquaQ #50170

Downloading input for 2017 day 16 to: :/home/jmcmurray/git/reQ/p16

```

## GitHub (`github.q`)

This script provides a very simple example of accessing the GitHub API. It 
contains a single function, for retrieving a basic summary of a GitHub repo.

In terms of config, the only value required here is an authorisation token for
the GitHub API, to be placed in `github.cfg`.

In standalone mode, it uses positional arguments to provide the repo
information, which can be either in the `user/repo` format or `user repo`. For
example:

```
$ q examples/github.q AquaQAnalytics/TorQ
KDB+ 3.5 2017.11.30 Copyright (C) 1993-2017 Kx Systems
l64/ 8()core 16048MB jmcmurray homer.aquaq.co.uk 127.0.1.1 EXPIRE 2018.06.30
AquaQ #50170

name            | "TorQ"
owner           | "AquaQAnalytics"
html_url        | "https://github.com/AquaQAnalytics/TorQ"
description     | "kdb+ production framework.  Read the doc:
http://aquaqanalytics.github.io/TorQ/.  Join the group!"
size            | 13394f
stargazers_count| 111f
watchers_count  | 111f

$ q examples/github.q jonathonmcmurray kdbslack
KDB+ 3.5 2017.11.30 Copyright (C) 1993-2017 Kx Systems
l64/ 8()core 16048MB jmcmurray homer.aquaq.co.uk 127.0.1.1 EXPIRE 2018.06.30
AquaQ #50170

name            | "kdbslack"
owner           | "jonathonmcmurray"
html_url        | "https://github.com/jonathonmcmurray/kdbslack"
description     | "A framework for a KDB back end to a Slack bot"
size            | 79f
stargazers_count| 1f
watchers_count  | 1f
```

The same function can be used by loading the script within a q session/script
and calling `.gh.repo[user;repo]` where `user` & `repo` are strings, and the
return is the dictionary.
