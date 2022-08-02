function r = polynint(p, n)
%POLYNINT Integrate polynomial N times.
%
%   POLYNINT(P, N) returns the polynomial P integrated N times.  P is a
%   vector of coefficients in decreasing order.
%
%   POLYNINT(P, -N) returns POLYNDER(P, N);
%
%   POLYNINT(P, 0) returns P.
%
%   See also POLYNDER, POLYDER, POLYINT.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:12:45 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(2, 2, nargin));

   %
   % First argument.
   %

   % Check array class.
   if ~isnumeric(p)
      error('P must be a numeric array.');
   end

   % Check array size.
   if (ndims(p) ~= 2) | (size(p, 1) ~= 1)
      error('P must be row vector.');
   end

   %
   % Second argument.
   %

   % Check array class.
   if ~isreal(n)
      error('N must be real.');
   end

   % Check array size.
   if any(size(n) ~= 1)
      error('N must be scalar.');
   end

   % Check array values.
   if (n ~= round(n))
      error('N must be an integer.');
   end

   if n > 0                     % do integration if n > 0
      m = length(p);
      for i = 1 : n
         c = m+i-1 : -1 : i;
         p = p ./ c;
      end
      r = zeros(1, m+n);
      r(1 : m) = p;
   elseif n < 0                 % do differentiation if n < 0
      r = polynder(p, -n);
   else                         % do nothing if n = 0
      r = p;
   end
