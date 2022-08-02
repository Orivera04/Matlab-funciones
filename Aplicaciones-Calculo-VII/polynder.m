function r = polynder(p, n)
%POLYNDER Differentiate polynomial N times.
%
%   POLYNDER(P, N) returns the N'th derivative of the polynomial whose
%   coefficients are the elements of the vector P.
%
%   POLYNDER(P, -N) returns POLYNINT(P, N).
%
%   POLYNDER(P, 0) returns P.
%
%   See also POLYNINT, POLYINT, POLYDER.

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

   if n > 0                     % do differentiation if n > 0
      m = length(p);
      r = p(1 : m-n);
      for i = 1 : n
         c = m-i : -1 : n+1-i;
         r = c .* r;
      end
   elseif n < 0                 % do integration if n < 0
      r = polynint(p, -n);
   else                         % do nothing if n = 0
      r = p;
   end
