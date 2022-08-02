function d = int2digits(i)
%INT2DIGITS Split an integer into digits.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-08 15:50:42 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   i = i(:);

   % this returns the returns the largest integer P such that 10^P <= I
   p = floor(log(i) / log(10));         % "estimate"
   k = i >= 10.^(p + 1);
   p(k) = p(k) + 1;                     % correction

   p = max(p);
   d = rem(floor(i*10.^(-p:0)), 10);
