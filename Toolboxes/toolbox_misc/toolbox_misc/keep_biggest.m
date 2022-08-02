function y = keep_biggest(x,n)

% keep_biggest - keep only the n biggest coef, 
%   set the rest to zero.
%
% y = keep_biggest(x,n);
%
%   Copyright (c) 2004 Gabriel Peyré

y = x;
[tmp,I] = sort(abs(y(:)));
y( I(1:end-n) ) = 0;