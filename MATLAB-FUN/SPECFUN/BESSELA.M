function [J,digits] = bessela(nu,x)
%BESSELA Fractional order Bessel functions and accuracy estimate.
%	Warning: May be inaccurate for large arguments.  See below.
%	J = bessela(nu,X) = Bessel function, J-sub-nu (X).
%	Bessel functions are solutions to Bessel's differential
%	equation of order nu:
%	         2                    2    2
%	        x * y'' +  x * y' + (x - nu ) * y = 0
%
%	The function is evaluated for every point in the array X.
%	The order, nu, must be a nonnegative scalar.
%
%	See also BESSEL, BESSELJ, BESSELI.
%
%	For some values of the arguments, this computation is
%	severely contaminated by roundoff error.  Consequently
%	[J,digits] = bessela(nu,x) returns an estimate of the
%	number of correct significant digits in the computed
%	result.  digits is the log10 of the estimated relative error,
%	so digits = 14 or 15 corresponds to nearly full accuracy
%	in IEEE or VAX arithmetic, while digits = 1 or 2 indicates
%	nearly useless results.  Any negative value of digits is
%	replaced by zero, the corresponding J set to NaN and a
%	division by zero warning message is generated.
%	If either nu or x is less than 50, digits will be at least 8.
%	In the (nu,x) plane, the region of least accuracy is near
%	the line nu = x, so small values of nu and large values of x,
%	or vice versa, give the most accurate results.
%	Here some representative values of digits:
%
%	                                  nu
%	                              25      75
%	                          --------------
%	                 x   25   |  11.8    14.4
%	                     75   |  14.5     1.9

%	Reference: Abramowitz and Stegun, Handbook of Mathematical
%	  Functions, National Bureau of Standards, Applied Math.
%	  Series no. 55, formulas 9.1.10 and 9.2.5.
%	C.B. Moler, 7-13-87, 4-20-90.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Temporarily replace x=0 with x=1
xz = abs(x)==0;
x = x + xz;

% Asymptotic series
KMIN = 12; % Try the series for at least KMIN/2 terms.
z = (-1)./(8*x).^2;
t = 0*x;
q = t;
t = t + 1;
p = t;
r = abs(t);
mu = 2*nu;
k = 0;
l = -1;
oka = abs(x) > 0.9*nu;
while any(any(abs(t) > eps*max(abs(p),abs(q)) & oka))
   s = t;
   k = k+1;
   l = l+2;
   t = (mu-l)*(mu+l)/k*t;
   q = q + t;
   k = k+1;
   l = l+2;
   t = (mu-l)*(mu+l)/k*t.*z;
   p = p+t;
   r = max(r,abs(t));
   if k >= 2*KMIN, oka = oka .* (abs(t) <= 5*abs(s)); end
end
q = q./(8*x);
y = x - (2*nu+1)*pi/4;
Ja = sqrt(2)./sqrt(pi*x) .* (p.*cos(y) - q.*sin(y));
da = max(oka.*log10(max(abs(p),abs(q))./(eps*abs(r))),0);
oka = oka.*(da > 0);

% If necessary, use power series expansion.
% Requires the gamma function from another M file
okp = da < 12;
if any(any(okp))
   t = okp .* (x/2).^nu / gamma(nu+1);
   s = t;
   r = abs(t);
   z = -(x/2).^2;
   k = 0;
   while any(any(abs(t) > eps*abs(s) & okp))
      k = k + 1;
      t = z.*t/(k*(nu+k));
      s = s + t;
      r = max(r,abs(t));
      okp = okp .* (eps*abs(r) <= abs(s));
   end
   Jp = s;
   dp = max(okp.*log10((1-okp+abs(s))./(1-okp+eps*abs(r))),0);
   okp = okp.*(dp > 0).*(dp>da);
   oka = oka.*(da>=dp);
   digits = oka.*da + okp.*dp;
   J = oka.*Ja + okp.*Jp + (0)./digits;
else
   J = Ja;
   digits = da;
end

% Restore results for x = 0; J0(0) = 1, Jnu(0) = 0 for nu > 0.
J = (1-xz).*J + xz*(nu==0);

if min(digits <= 12) & (nargout < 2)
   disp(' ');
   disp('Warning: Results from BESSEL may be inaccurate.')
   disp('Use BESSELA with two output arguments.')
   disp('[result,digits] = bessela(nu,x).')
end
