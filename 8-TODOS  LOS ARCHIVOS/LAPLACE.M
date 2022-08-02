function F = laplace(f,s,t)
%LAPLACE Laplace transform.
%	F = LAPLACE(f) is the Laplace transform of the symbolic expression f,
%	    F(s) = int(f(t)*exp(-s*t),'t',0,inf)
%	F = LAPLACE(f,'v') is a function of 'v' instead of 's'.
%	F = LAPLACE(f,'v','x') assumes f is a function of 'x' instead of 't'.
%	F = LAPLACE, with no input arguments, transforms the previous result.
%
%	Examples:
%	    laplace exp(t)               1/(s-1)
%	    laplace t^2+sin(t)           (2*s^2+2+s^3)/s^3/(s^2+1)
%	    laplace('y^(3/2)','z')       3/4*pi^(1/2)/z^(5/2)
%	    laplace(diff('F(t)'))        laplace(F(t),t,s)*s-F(0)
%
%	See also INVLAPLACE, FOURIER, ZTRANS.

%	Copyright (c) 1993-94 by The MathWorks, Inc

if nargin == 0
   f = maple('"');
elseif strcmp(f,'ans')
   f = maple('"');
end
if nargin < 2
   s = 's';
end
if nargin < 3
   t = symvar(f,'t');
end
F = maple('laplace',f,t,s);
