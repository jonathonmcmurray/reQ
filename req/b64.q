\d .b64

// @kind function
// @category public
// @fileoverview base64 encode a string. Where available, defaults to .Q.btoa built-in
// @param x {string} string to be encoded
// @return {string} encoded string
enc:{(neg[c] _ .Q.b6 0b sv' 00b,/:6 cut raze (0b vs'`byte$x),(8*c)#0b),(c:neg[count x]mod 3)#"="}
enc:@[value;`.Q.btoa;{[x;y]x}enc]

// @kind function
// @category public
// @fileoverview base64 decode a string
// @param x {string} base64 string to be decoded
// @return {string} decoded string
dec:{(`char$0b sv'8 cut raze 2_'0b vs'`byte$.Q.b6?x) except "\000"}

\d .
