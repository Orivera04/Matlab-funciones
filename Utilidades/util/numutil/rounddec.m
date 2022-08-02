function y = rounddec(x, n)
%ROUNDDEC Round to a specified number of decimals.
%
%   Y = ROUNDDEC(X, N) rounds the elements of X to N decimals.
%
%   For instance, rounddec(10*sqrt(2) + i*pi/10, 4) returns
%   14.1421 + 0.3142i
%
%   See also: ROUND, FIX, FLOOR, CEIL, ROUNDDIG, TRUNCDEC, TRUNCDIG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-14 00:56:09 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(2, 2, nargin));

   % Quick exit if either argument is empty.
   if isempty(x) | isempty(n)
      y = [];
      return
   end

   % Get size of input arguments.
   size_x   = size(x);
   size_n   = size(n);
   scalar_x = all(size_x == 1);         % True if x is a scalar.
   scalar_n = all(size_n == 1);         % True if n is a scalar.

   % Check size of input arguments.
   if ~scalar_x & ~scalar_n & ~isequal(size_x, size_n)
      error(['When both arguments are non-scalars they must have' ...
             ' the same size']);
   end

   f = 10.^n;
   y = round(x .* f) ./ f;
