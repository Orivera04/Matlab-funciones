function y = tandeg(x)
%TANDEG Tangent of argument in degrees.
%
%   TANDEG(X) is the tangent of the elements of X, when the unit is degrees.
%
%   See also TAN, TANGRAD, ATAN, ATANDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 17:57:26 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = tan((pi / 180) * x);

   % fix cases when output can be represented exactly
   x = x - 360 * floor(x / 360);
   y(x == 0 | x == 180) = 0;
   y(x == 90 | x == 270) = NaN;
