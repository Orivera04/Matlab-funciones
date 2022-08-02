function y = sindeg(x)
%SINDEG Sine of argument in degrees.
%
%   SINDEG(X) is the sine of the elements of X, when the unit is degrees.
%
%   See also SIN, SINGRAD, ASIN, ASINDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:25:47 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = sin((pi / 180) * x);

   % fix cases when output can be represented exactly
   x = x - 360 * floor(x / 360);
   y(x == 0 | x == 180) = 0;
   y(x ==  90) =  1;
   y(x == 270) = -1;
