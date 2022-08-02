function y = reshape(x,m,n)
%RESHAPE Change size.
%	RESHAPE(X,M,N) returns the M-by-N matrix whose elements
%	are taken columnwise from X.  An error results if X does
%	not have M*N elements.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[mm,nn] = size(x);
if mm*nn ~= m*n
    error('Matrix must have M*N elements.')
end

if ~issparse(x)
   y = zeros(m,n);
   y(:) = x;
else
   [i,j,s] = find(x);
   k = (j-1)*mm + i;
   i = rem(k-1,m) + 1;
   j = (k-i)/m + 1;
   y = sparse(i,j,s,m,n);
end
