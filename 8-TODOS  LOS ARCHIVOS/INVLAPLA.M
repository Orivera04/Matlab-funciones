function f = invlaplace(F,t,s)
%INVLAPLACE Inverse Laplace transform.
%	f = INVLAPLACE(F) is the inverse Laplace transform of the expression F,
%	    f(t) = int(F(s)*exp(s*t),'s',0,inf)
%	f = INVLAPLACE(F,'x') is a function of 'x' instead of 't'.
%	f = INVLAPLACE(F,'x','v') assumes F is a function of 'v' instead 's'.
%	f = INVLAPLACE, with no input arguments, transforms the previous result.
%
%	Examples:
%	    invlaplace 1/(s-1)                         exp(t)
%	    invlaplace('(2*s^2+2+s^3)/s^3/(s^2+1)')    t^2+sin(t)
%	    invlaplace('t^(-5/2)','x')                 4/3/pi^(1/2)*x^(3/2)
%	    invlaplace('laplace(f(t))')                f(t)
%
%	See also LAPLACE, INVFOURIER, INVZTRANS.

%	Copyright (c) 1993-94 by The MathWorks, Inc

if nargin == 0
   F = maple('"');
elseif strcmp(F,'ans')
   F = maple('"');
end
if nargin < 2
   t = 't';
end
if nargin < 3
   s = symvar(F,'s');
end
f = maple('invlaplace',F,s,t);
