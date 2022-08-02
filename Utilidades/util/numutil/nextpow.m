function p = nextpow(x, n)
%NEXTPOW Nextious power.
%
%   P = NEXTPOW(X, N) returns the smallest integer P such that N^P >= abs(X).
%
%   Essentially, NEXTPOW(X, N) is the same as CEIL(LOG(ABS(X)) / LOG(N)), but
%   special care is taken to catch round-off errors.
%
%   See also PREVPOW, NEXTPOWOF2, NEXTPOWOF10.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:38:03 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(2, 2, nargin));

   if ~isreal(x)
      error('Input must be real.');
   end

   x = abs(x);
   p = ceil(log(x) ./ log(n));          % estimate
   k = x <= n.^(p - 1);
   p(k) = p(k) - 1;                     % correction
