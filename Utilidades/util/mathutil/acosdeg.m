function y = acosdeg(x)
%ACOSDEG Inverse cosine with degrees as unit.
%
%   ACOSDEG(X) is the arccosine of the elements of X, when the unit is degrees.
%
%   See also ACOS, ACOSGRAD, COS, COSDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:23:16 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = (180 / pi) * acos(x);
