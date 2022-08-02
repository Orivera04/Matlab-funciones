function r = polypow(p, n)
%POLYPOW Multiply polynomials.
%
%   R = POLYPOW(P, N) returns the polynomial P raised to the Nth power.
%
%   P is a vector of coefficients in decreasing order.
%
%   See also POLYADD, POLYSUB, POLYMUL, POLYDIV.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:30:13 +0100
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
   if (n < 0) | (n ~= round(n))
      error('N must be a non-negative integer.');
   end

   if n == 0
      r = 1;
   elseif n == 1
      r = p;
   else
      s = p;
      r = 1;
      n = n / 2;
      while 1
         if rem(n, 1)
            r = conv(r, s);
            n = fix(n);
         end
         if n
            s = conv(s, s);
            n = n / 2;
         else
            break
         end
      end
   end
