function x = chebextr(n)
%CHEBEXTR Extreme values of Chebychev polynomial of the first kind.
%
%   X = CHEBEXTR(N) returns the location of the local extreme values of the
%   Chebychev polynomial of the first kind of degree N.
%
%   All local extreme values of the polynomial are either -1 or 1.  So,
%   CHEBPOLY(N, CHEBEXTR(N))) is equivalent to (-1).^(N:-1:0), but former may
%   contain some numerical noise.
%
%   CHEBEXTR(N) is equivalent TO [-1, SORT(ROOTS(POLYDER(CHEBPOLY(N))))', 1],
%   but the former is more accurate.
%
%   See also CHEBPOLY, CHEBROOT.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:00:23 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 2, nargin));

   % Check array class.
   if ~isa(n, 'double')
      error('N must be double.');
   end

   % Check array size.
   if any(size(n) ~= 1)
      error('N must be scalar.');
   end
   
   % Check array values.
   if ~isreal(n) | (n < 0) | (n ~= round(n))
      error('N must be a real non-negative integer');
   end

   %
   % Quick exit for the simple case N = 0.
   %

   if n == 0
      x = 0;
   end

   %
   % The general case, when N > 0.
   %

   x = cos((pi / n) * (n : -1 : 0));

   % Remove numerical noise for the case when the extreme is 0.
   if ~rem(n, 2)
      x(n / 2 + 1) = 0;
   end
