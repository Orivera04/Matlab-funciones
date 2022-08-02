function y = cosdeg(x)
%COSDEG Cosine of argument in degrees.
%
%   COSDEG(X) is the cosine of the elements of X, when the unit is degrees.
%
%   See also COS, COSGRAD, ACOS, ACOSDEG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:13:58 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = cos((pi / 180) * x);

   % fix cases when output can be represented exactly
   x = x - 360 * floor(x / 360);
   y(x == 90 | x == 270) = 0;
   y(x == 0) = 1;
   y(x == 180) = -1;
