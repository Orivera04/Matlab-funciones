function y = cuberoot(x)
%CUBEROOT Compute cubic root and return real cubic root for real numbers.
%
%   CUBEROOT(X) returns the cubic root of the elements of X.  X must be real.
%   Output is negative for each negative input.
%
%   For example:
%
%      cuberoot([-8, -1, 0, 1, 8, 27])
%
%   returns the vector
%
%      [-2, -1, 0, 1, 2, 3]
%
%   See also POWER.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-09 15:27:31 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isa(x, 'double')
      error('X must be a double array.');
   end

   % Check array values.
   if ~isreal(x)
      error('X must be a real array.');
   end

   % Initialize Y to X so we preserve Inf's and NaN's.
   y = x;

   % Compute the cubic root of finite and real numbers.
   k = isfinite(x);
   y(k) = sign(x(k)) .* abs(x(k)).^(1/3);

   % Correct numerical errors (since, e.g., 64^(1/3) is not exactly 4) by one
   % iteration of Newton's method.
   y(k) = y(k) - (y(k).^3 - x(k)) ./ (3 * y(k).^2);
