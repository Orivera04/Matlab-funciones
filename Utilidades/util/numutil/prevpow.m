function p = prevpow(x, n)
%PREVPOW Previous power.
%
%   P = PREVPOW(X, N) returns the largest integer P such that N^P <= abs(X).
%
%   Essentially, PREVPOW(X, N) is the same as FLOOR(LOG(ABS(X)) / LOG(N)), but
%   special care is taken to catch round-off errors.
%
%   See also NEXTPOW, PREVPOWOF2, PREVPOWOF10.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:38:03 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(2, 2, nargin));

   if ~isreal(x)
      error('Input must be real.');
   end

   x = abs(x);
   p = floor(log(x) ./ log(n));         % estimate
   k = x >= n.^(p + 1);
   p(k) = p(k) + 1;                     % correction
