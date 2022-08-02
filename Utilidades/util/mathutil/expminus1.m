function y = expminus1(x)
%EXPMINUS1 Exponential minus one.
%
%   EXPMINUS1(X) is EXP(X)-1 calculated in a way which is numerically better
%   than using EXP(X)-1 directly when X is close to zero.
%
%   See also LOGP1, LOG, EXP.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-09 17:46:51 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isa(x, 'double')
      error('Input must be double.');
   end

   y = exp(x) - 1;

   % find the cases that need special care; this is when
   % log(0.9) = -0.105360515657826 < x < log(2) = 0.693147180559945
   i = (-0.1 < real(y)) & (real(y) < 1);

   % one Newton step for solving log(1 + y) = x
   y(i) = y(i) - (1 + y(i)) .* (log1p(y(i)) - x(i));

   return

   % this works but depends on a highly accurate sinh function
   y(i) = 2 * exp(x(i) / 2) .* sinh(x(i) / 2);
