function [q, r] = polydiv(a, b)
%POLYDIV Divide polynomials.
%
%   [Q, R] = POLYDIV(A, B) returns the polynomial A devided by the
%   polynomial B which results in a quotient Q and a remainder R.
%
%   POLYDIV is essentially a call to DECONV.
%
%   See also POLYADD, POLYSUB, POLYMUL, POLYPOW, DECONV.

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
   
   [q, r] = deconv(a, b);
