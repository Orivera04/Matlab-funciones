function x = norm(x, p)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if (nargin==1) p = 2; end
x = sum(abs(x).^p).^(1/p);
