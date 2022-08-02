function y = keep_above(x,T)

% keep_above - keep only the coefficients above threshold T, 
%   set the rest to zero.
%
% y = keep_above(x,T);
%
%   Copyright (c) 2004 Gabriel Peyré

I = find(abs(x)<T);
y = x;
y(I) = 0;