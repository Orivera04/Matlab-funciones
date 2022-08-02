function y = atan2grad(y, x)
%ATAN2GRAD Four quadrant inverse tangent of argument in gradians.
%
%   ATAN2GRAD(Y, X) is the four quadrant arctangent of the elements of X, when
%   the unit is gradians.
%
%   See also ATAN2, ATAN2DEG, TAN, TANGRAD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 17:43:43 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(2, 2, nargin));

   % check array class
   if ~isnumeric(x) | ~isnumeric(y)
      error('Input must be numeric arrays.');
   end

   y = (200 / pi) * atan2(y, x);
