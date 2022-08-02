function y = asingrad(x)
%ASINGRAD Inverse sine with gradians as unit.
%
%   ASINGRAD(X) is the arcsine of the elements of X, when the unit is gradians.
%
%   See also ASIN, ASINDEG, SIN, SINGRAD.

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

   y = (200 / pi) * asin(x);
