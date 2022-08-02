function y = betainc(x,a,b)
%BETAINC Incomplete beta function.
%	Y = BETAINC(X,A,B).
%	The elements of X must be in the interval [0,1].
%	The arguments X, A and B must all be the same size except that scalar
%	arguments function as constant matrices of the common size of the other
%	arguments.
%	See also BETA.

%	Ref: Abramowitz & Stegun, Handbook of Mathemtical Functions, sec. 26.5.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if any(any(x < 0 | x > 1)) | any(any(imag(x) ~= 0))
   error('In betainc(x,a,b), x must be in the interval [0,1].')
end

if nargin < 3
   error('Requires three input arguments.')
end

m = max(size(x,1),max(size(a,1),size(b,1)));
n = max(size(x,2),max(size(a,2),size(b,2)));

y = zeros(m,n);
bt = exp(gammaln(a+b)-gammaln(a)-gammaln(b) + a.*log(x) + b.*log(1-x));

k = find(x < (a+1) ./ (a+b+2));
if length(k) > 0
   if length(x) == 1, xk = x; else, xk = x(k); end
   if length(a) == 1, ak = a; else, ak = a(k); end
   if length(b) == 1, bk = b; else, bk = b(k); end
   y(k) = bt(k) .* betacore(xk,ak,bk) ./ ak;
end

k = find(x >= (a+1) ./ (a+b+2));
if length(k) > 0
   if length(x) == 1, xk = x; else, xk = x(k); end
   if length(a) == 1, ak = a; else, ak = a(k); end
   if length(b) == 1, bk = b; else, bk = b(k); end
   y(k) = 1 - bt(k) .* betacore(1-xk,bk,ak) ./ bk;
end
