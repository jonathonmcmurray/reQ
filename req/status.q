\d .status

// @kind function
// @category private
// @fileoverview get status "class" from status code, header dict or return object
// @param x {int|dict|(dict;string)} status code, header dict or return object
// @return {int} status class
class:{c:div[;100];$[0=type x;.z.s[first x];99=type x;c x`status;c x]}              //get class from status code, header dict or return object

/TODO: add dict of status codes

\d .