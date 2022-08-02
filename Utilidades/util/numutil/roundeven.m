function y = roundeven(x)
%ROUNDEVEN Round towards nearest integer (pick even in .5 cases)
%
%   ROUNDEVEN(X) rounds the elements of X to the nearest integer.  In cases
%   where the fractional part is .5, the results is rounded to the nearest
%   even integer.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:18:38 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % do the real part of x
   rx  = real(x);
   arx = abs(rx);
   rrx = round(rx);
   k = (rx - floor(rx)) == 0.5 & rem(rrx, 2);
   rrx(k) = fix(rx(k));

   if isreal(x)

      % no imaginary part; so assign directly
      y = rrx;

   else

      % do the imaginary part of x
      ix  = imag(x);
      aix = abs(ix);
      rix = round(ix);
      k = (ix - floor(ix)) == 0.5 & rem(rix, 2);
      rix(k) = fix(ix(k));

      % build output
      y = complex(rrx, rix);

   end
