function y = atangrad(x)
%ATANGRAD Inverse tangent of argument in gradians.
%
%   ATANGRAD(X) is the arctangent of the elements of X, when the unit is
%   gradians.
%
%   See also ATAN, ATANDEG, TAN, TANGRAD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:03:31 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = (200 / pi) * atan(x);
