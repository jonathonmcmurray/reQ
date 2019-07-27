# reQ

---

Open source HTTP requests library for kdb+/q

A more fully-featured alternative to kdb+ built-in functions `.Q.hg` and `.Q.hp`, which provide basic HTTP query functionality.

Features include:

* Support for [custom headers](features/headers.md)
* [Cookies](features/cookies.md)
* Automatic conversion of JSON response to kdb+ object
* Backwards compatible with older versions of kdb+ - tested from v2.8+
* Follows [HTTP redirection](features/redirects.md)
* [Verbose mode](features/verbose.md) to show raw requests & responses
