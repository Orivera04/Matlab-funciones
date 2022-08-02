function y = cosgrad(x)
%COSGRAD Cosine of argument in gradians.
%
%   COSGRAD(X) is the cosine of the elements of X, when the unit is gradians.
%
%   See also COS, COSDEG, ACOS, ACOSGRAD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 18:23:33 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   y = cos((pi / 200) * x);

   % fix cases when output can be represented exactly
   x = x - 400 * floor(x / 400);
   y(x == 100 | x == 300) = 0;
   y(x ==   0) =  1;
   y(x == 200) = -1;
