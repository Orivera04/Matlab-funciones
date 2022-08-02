function p = prevpowof2(x)
%PREVPOWOF2 Previous power of 2.
%
%   P = PREVPOWOF2(X) returns the largest integer P such that 2^P <= abs(X).
%
%   Essentially, PREVPOWOF2(X) is the same as FLOOR(LOG2(ABS(X))), but
%   special care is taken to catch round-off errors.
%
%   See also NEXTPOWOF2, PREVPOW.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:38:03 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   if ~isreal(x)
      error('Input must be real.');
   end

   x = abs(x);
   p = floor(log2(x));                  % estimate
   k = x >= pow2(p + 1);
   p(k) = p(k) + 1;                     % correction
