\d .utl

cfg:{(!/)"S*"$flip "=" vs'read0 ` sv`:examples,` sv x,`cfg}
writecfg:{(` sv`:examples,` sv x,`cfg)0:"="sv'flip({string key x};value)@\:y}
