function y = singrad(x)
%SINGRAD Sine of argument in gradians.
%
%   SINGRAD(X) is the sine of the elements of X, when the unit is gradians.
%
%   See also SIN, SINDEG, ASIN, ASINGRAD.

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

   y = sin((pi / 200) * x);

   % fix cases when output can be represented exactly
   x = x - 400 * floor(x / 400);
   y(x == 0 | x == 200) = 0;
   y(x == 100) =  1;
   y(x == 300) = -1;
