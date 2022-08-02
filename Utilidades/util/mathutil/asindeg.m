function y = asindeg(x)
%ASINDEG Inverse sine with degrees as unit.
%
%   ASINDEG(X) is the arcsine of the elements of X, when the unit is degrees.
%
%   See also ASIN, ASINGRAD, SIN, SINDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:25:23 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = (180 / pi) * asin(x);
