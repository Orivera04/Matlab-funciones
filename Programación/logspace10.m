function y = logspace10(d1, d2, n)
%LOGSPACE10 Logarithmically spaced vector.
%
%   LOGSPACE10(d1, d2) generates a row vector of 100 logarithmically equally
%   spaced points between 10^d1 and 10^d2.
%
%   LOGSPACE10(d1, d2, N) generates N points.
%
%   The main difference between LOGSPACE10 and LOGSPACE (MATLAB) is that
%   LOGSPACE10 does not treat D2 = PI as special.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 14:58:41 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(2, 3, nargin));

   if nargin < 3
      n = 100;
   end

   y = 10 .^ [d1 + (0:n-2)*(d2-d1)/(n-1), d2];
