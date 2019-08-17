\d .b64

// @kind function
// @category public
// @fileoverview base64 encode a string
// @param x {string} string to be encoded
// @return {sting} encoded string
enc:{(neg[c] _ .Q.b6 0b sv' 00b,/:6 cut raze (0b vs'`byte$x),(8*c)#0b),(c:neg[count x]mod 3)#"="}

// @kind function
// @category public
// @fileoverview base64 decode a string
// @param x {string} base64 string to be decoded
// @return {sting} decoded string
dec:{(`char$0b sv'8 cut raze 2_'0b vs'`byte$.Q.b6?x) except "\000"}

\d .
