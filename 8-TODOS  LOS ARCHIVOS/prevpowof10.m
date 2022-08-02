function p = prevpowof10(x)
%PREVPOWOF10 Previous power of 10.
%
%   P = PREVPOWOF10(X) returns the largest integer P such that 10^P <= abs(X).
%
%   Essentially, PREVPOWOF10(X) is the same as FLOOR(LOG(ABS(X)) / LOG(10)),
%   but special care is taken to catch round-off errors.
%
%   See also NEXTPOWOF10, PREVPOW.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:38:03 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   if ~isreal(x)
      error('Input must be real.');
   end

   x = abs(x);
   p = floor(log(x) / log(10));         % estimate
   k = x >= 10.^(p + 1);
   p(k) = p(k) + 1;                     % correction
