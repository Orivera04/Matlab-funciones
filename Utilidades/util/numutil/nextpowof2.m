function p = nextpowof2(x)
%NEXTPOWOF2 Next power of 2.
%
%   P = NEXTPOWOF2(X) returns the smallest integer P such that 2^P >= abs(X).

%   Essentially, NEXTPOWOF2(X, N) is the same as CEIL(LOG2(ABS(X))), but
%   special care is taken to catch round-off errors.
%
%   See also PREVPOWOF2, NEXTPOW.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:38:03 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   if ~isreal(x)
      error('Input must be real.');
   end

   x = abs(x);
   p = ceil(log2(x));                   % estimate
   k = x <= pow2(p - 1);
   p(k) = p(k) - 1;                     % correction
