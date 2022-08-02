function y = tangrad(x)
%TANGRAD Tangent of argument in gradians.
%
%   TANGRAD(X) is the tangent of the elements of X, when the unit is gradians.
%
%   See also TAN, TANDEG, ATAN, ATANGRAD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 17:49:09 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = tan((pi / 200) * x);

   % fix cases when output can be represented exactly
   x = x - 400 * floor(x / 400);
   y(x ==   0 | x == 200) =   0;
   y(x == 100 | x == 300) = NaN;
