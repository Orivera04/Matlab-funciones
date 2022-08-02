function f = invztrans(F,n,z)
%INVZTRANS Inverse Z transform.
%	f = INVZTRANS(F) is the inverse Z transform of the expression F,
%	    f(n) = 1/(2*pi*i)*(a complex contour integral of F(z)*z^(n-1) dz).
%	f = INVZTRANS(F,'x') is a function of 'x' instead of 'n'.
%	f = INVZTRANS(F,'x','v') assumes F is a function of 'v' instead of 'z'.
%	f = INVZTRANS, with no input arguments, transforms the previous result.
%
%	Examples:
%	   invztrans z/(z-1)                 1
%	   invztrans z/(z-a)                 a^n
%	   invztrans('exp(x/z)','k','z')     x^k/k!
%	   invztrans(ztrans('f(n)'))         f(n)
%
%	See also ZTRANS, INVLAPLACE, INVFOURIER.

%	Copyright (c) 1993-94 by The MathWorks, Inc

if nargin == 0
   F = maple('"');
elseif strcmp(F,'ans')
   F = maple('"');
end
if nargin < 2
   n = 'n';
end
if nargin < 3
   z = symvar(F,'z');
end
f = maple('invztrans',F,z,n);
