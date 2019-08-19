.utl.require"req";                                                                  //import module
system"l ",getenv[`AXLIBRARIES_HOME],"/ws/qlint.q_";                                //load linter
rt:delete from .qlint.rules.defaultRules where label in `MISSING_DEPENDENCY`RESERVED_NAME`VAR_Q_ERROR`DEPRECATED_DATETIME;
/ MISSING_DEPENDENCY - doesn't properly handle dependencies in other namespaces
/ RESERVED_NAME - .req.get, .req.delete, .url.parse ...
/ VAR_Q_ERROR - use "host" as variable in oplaces
/ DEPRECATED_DATETIME - used in cookie code

fn:{if[104=type v:$[-11=type x;value;] x;:.z.s first value v];`$first -3#value v}   //get filename
ln:{if[104=type v:$[-11=type x;value;] x;:.z.s first value v];first -2#value v}     //get line number of function

t:update
	fname:fn'[qualifiedName],
	startLine+ln'[qualifiedName],
	endLine+ln'[qualifiedName]
	from .qlint.lintNS[`.req`.b64`.url`.cookie`.status`.auth;rt];

-1 .qlint.i.writers.stdout t;

if[not count .z.x;exit count t];                                                    //keep alive if any args on cmd line
