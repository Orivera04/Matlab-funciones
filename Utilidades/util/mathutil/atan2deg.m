function y = atan2deg(y, x)
%ATAN2DEG Four quadrant inverse tangent of argument in degrees.
%
%   ATAN2DEG(Y, X) is the four quadrant arctangent of the elements of X, when
%   the unit is degrees.
%
%   See also ATAN2, ATAN2GRAD, TAN, TANDEG.

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

   y = (180 / pi) * atan2(y, x);
