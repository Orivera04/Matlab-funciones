function F = ztrans(f,z,n)
%ZTRANS Z transform.
%	F = ZTRANS(f) is the Z transform of the symbolic expression f,
%	    F(z) = symsum(f(n)/z^n,'n',0,inf)
%	F = ZTRANS(f,'v') is a function of 'v' instead of 'z'.
%	F = ZTRANS(f,'v','x') assumes f is a function of 'x' instead 'n'.
%	F = ZTRANS, with no input arguments, transforms the previous result.
%
%	Examples:
%	   ztrans 1                     z/(z-1)
%	   ztrans a^n                   z/(z-a)
%	   ztrans sin(n*pi/2)           z/(1+z^2)
%	   ztrans('x^k/k!','z','k')     exp(1/z*x)
%	   ztrans('f(n+1)')             z*ztrans(f(n),n,z)-f(0)*z
%
%	See also INVZTRANS, LAPLACE, FOURIER.

%	Copyright (c) 1993-94 by The MathWorks, Inc

if nargin == 0
   f = maple('"');
elseif strcmp(f,'ans')
   f = maple('"');
end
if nargin < 2
   z = 'z';
end
if nargin < 3
   n = symvar(f,'n');
end
F = maple('ztrans',f,n,z);
