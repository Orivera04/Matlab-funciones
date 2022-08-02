function f = invfourier(F,t,w)
%INVFOURIER Inverse Fourier integral transform.
%	f = INVFOURIER(F) is the inverse Fourier transform of the expression F,
%	    f(t) = 1/(2*pi)*int(F(w)*exp(i*w*t),'w',-inf,inf)
%	f = INVFOURIER(F,'x') is a function of 'x' instead of 't'.
%	f = INVFOURIER(F,'x','v') assumes F is a function of 'v' instead of 'w'.
%	f = INVFOURIER, with no input arguments, transforms the previous result.
%
%	Examples:
%	    invfourier exp(-w^2)         1/2/pi^(1/2)*exp(-1/4*t^2)
%	    invfourier 1/(w-i)           i*exp(-t)*Heaviside(t)
%
%	See also FOURIER, INVLAPLACE, INVZTRANS.

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
   w = symvar(F,'w');
end
f = maple('invfourier',F,w,t);
