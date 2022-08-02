function y = beta(z,w,v)
%BETA	Beta function.
%	y = beta(z,w).
%	y = integral from 0 to 1 of t.^(z-1) .* (1-t).^(w-1) dt.
%	z and w must be compatible for addition.
%	Incomplete beta function.
%       y = beta(x,a,b).
%       The elements of x must be in the interval [0,1].
%       a and b must be scalars.
%
%	See also BETAINC, BETALN.

%	C. Moler, 2-1-91.
%	Ref: Abramowitz & Stegun, sec. 6.2.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 2
	y = exp(gammaln(z)+gammaln(w)-gammaln(z+w));
elseif nargin == 3
	y = betainc(z,w,v);
end
