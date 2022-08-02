function y = polyvalm(c,x)
%POLYVALM Matrix polynomial evaluation.
%	If  V  is a vector whose elements are the coefficients of a
%	polynomial,  then   POLYVALM(V,X)   is  the   value  of  the
%	polynomial evaluated with matrix argument X.  See POLYVAL
%	for polynomial evaluation in the regular or array sense.


%	J.N.Little 4-20-86
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Polynomial evaluation c(x) using Horner's method 

nc = max(size(c));
[m,n] = size(x);
if m ~= n
    error('Matrix must be square.')
end

y = zeros(m);
for i=1:nc
    y = x * y + c(i) * eye(m);
end
