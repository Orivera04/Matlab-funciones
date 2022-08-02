function y = acosgrad(x)
%ACOSGRAD Inverse cosine with gradians as unit.
%
%   ACOSGRAD(X) is the arccosine of the elements of X, when the unit is
%   gradians.
%
%   See also ACOS, ACOSDEG, COS, COSGRAD.

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

   y = (200 / pi) * acos(x);
