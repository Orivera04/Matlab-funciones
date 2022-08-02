function y = atandeg(x)
%ATANDEG Inverse tangent of argument in degrees.
%
%   ATANDEG(X) is the arctangent of the elements of X, when the unit is
%   degrees.
%
%   See also ATAN, ATANGRAD, TAN, TANDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:03:28 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = (180 / pi) * atan(x);
