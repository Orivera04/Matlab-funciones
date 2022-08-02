function r = polyadd(p, q)
%POLYADD Add polynomials.
%
%   R = POLYADD(P, Q) adds the polynomials whose coefficients are the
%   elements of the vectors P and Q.
%
%   See also POLYADD, POLYSUB, POLYMUL, POLYDIV, POLYPOW.

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
   
   m = length(p);
   n = length(q);
   l = max(m, n);

   r = zeros(1, l);                     % Initialize output.
   r(l-m+1:l) = p;                      % Insert first polynomial.
   r(l-n+1:l) = r(l-n+1:l) + q;         % Add second polynomial

   r = polytrim(r);                     % Trim the result.
