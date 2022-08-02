function r = polysub(p, q)
%POLYSUB Subtract polynomials.
%
%   R = POLYSUB(P, Q) subtract the polynomial Q from the polynomial P.
%
%   P and Q are vectors of coefficients in decreasing order.
%
%   See also POLYADD, POLYMUL, POLYDIV, POLYPOW.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:00:23 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(2, 2, nargin));

   % Check array class.
   if ~isnumeric(p) | ~isnumeric(q)
      error('P and Q must be numeric arrays.');
   end

   % Check array size.
   if (ndims(p) ~= 2) | (size(p, 1) ~= 1) | ...
      (ndims(q) ~= 2) | (size(q, 1) ~= 1)
      error('P and Q must be row vectors.');
   end

   r = polyadd(p, -q);
