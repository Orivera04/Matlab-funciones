function y = invmod(x,p)

% invmod - compute inverse modulo p of x.
%
%   y = invmod(x,p);
%
%   Copyright (c) 2003 Gabriel Peyr�

[u,y,d] = gcd(x,p); 
y = mod(y,p);