# reQ

[![Anaconda-Server Badge](https://anaconda.org/jmcmurray/req/badges/version.svg)](https://anaconda.org/jmcmurray/req)
[![Anaconda-Server Badge](https://anaconda.org/jmcmurray/req/badges/downloads.svg)](https://anaconda.org/jmcmurray/req)

HTTP requests library in kdb+/q

kdb+ has built in functions for HTTP requests such as `.Q.hg` (GET) and `.Q.hp`(POST). However, these functions are somewhat limited by several factors. For example, using these functions you cannot supply custom HTTP headers within the requests (for example, authorization tokens that are required by many APIs, a user agent etc.). In addition, in case of an HTTP redirect response, `.Q.hg`/`.Q.hp` will fail.

reQ is a library designed to overcome these limitations for basic HTTP queries. The main features are:

* Custom headers
* Automatic following of HTTP redirects
* Automatic parsing of JSON responses to KDB+ object
* Support for lower versions of KDB+ (tested on 2.7 & 3.3)
* Cookie support

For more details on features & usage, please see the [docs](http://jmcmurray.co.uk/reQ/)

## Getting started

### Standalone `.q` script

The simplest way for most people to get started with reQ will be via the standalone
`.q` file available from the [Releases](https://github.com/jonathonmcmurray/reQ/releases)
tab of this repo. Download the `.q` script from the latest release & this can be loaded
directly with `\l` when placed in project directory or `QHOME` etc.

```q
q)\l req_0.1.3.q
q).req.g"https://httpbin.org/get"
args   | (`symbol$())!()
headers| `Accept`Host`User-Agent`X-Amzn-Trace-Id!("*/*";"httpbin.org";"kdb+/3..
origin | "90.249.33.209"
url    | "https://httpbin.org/get"
```

### qutil package via Anaconda

Alternatively, reQ can be installed as a [qutil](https://github.com/nugend/qutil) via
[Anaconda](https://www.anaconda.com/)/[Miniconda](https://docs.conda.io/en/latest/miniconda.html)

Assuming conda is installed, installation command is:

```bash
$ conda install -c jmcmurray req
```

And package will then be available in q via:

```q
q).utl.require"req"
```

### Standalone qutil package

If you want to use qutil package, but not via Anaconda, you can also download
the package as a `.tar.gz` from the [Releases](https://github.com/jonathonmcmurray/reQ/releases)
tab & extract to your `QPATH` directory.


## Updating documentation with `qDoc`

Using `qDoc` from Kx (included with Kx Developer)

```bash
$ q $AXLIBRARIES_HOME/ws/qdoc.q_ -src req/ -out docs/api/
..
$ mkdocs serve # to preview locally
..
$ mkdocs gh-deploy # to deploy to github
```

## Linting with qlint

Uses `qlint.q_` from Kx (included with Kx Developer). Assumes `AXLIBRARIES_HOME`
env var is set

```bash
$ q lint.q
```

Loads package & lints `.req` & related namespaces. Some errors/warnings
excluded. Adding an additional arg on cmd line will halt process to inspect
output table `t`.

## Building releases

To build a release, `build.sh` is used. The script creates the unified, standalone
`.q` script & the `.tar.gz` of qutil package.

Argument is version number e.g.

```bash
$ ./build.sh 0.1.3
```