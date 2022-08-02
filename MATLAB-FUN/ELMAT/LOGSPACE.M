function y = logspace(d1, d2, n)
%LOGSPACE Logarithmically spaced vector.
%	LOGSPACE(d1, d2) generates a row vector of 50 logarithmically
%	equally spaced points between decades 10^d1 and 10^d2.  If d2
%	is pi, then the points are between 10^d1 and pi.
%
%	LOGSPACE(d1, d2, N) generates N points.
%
%	See also LINSPACE, :.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 2
    n = 50;
end
if d2 == pi
    d2 = log10(pi);
end
y = (10).^ [d1+(0:n-2)*(d2-d1)/(n-1), d2];
