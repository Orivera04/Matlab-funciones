function y = cloglog( x )
%CLOGLOG The complementary log log transformation.
%
%   The complementary log log transformation tranformation maps the interval
%   (0,1) to the whole real line.  The transformation is Y = LOG(-LOG(1 - X)).
%
%   See also ICLOGLOG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:51:45 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   y = zeros(size(x));
   y(:) = NaN;

   % Case when 0 < X and X < 1:
   i = (0 < x) & (x < 1);
   if any(i(:))
      y(i) = log(-log(1 - x(i)));
   end

   % Case when X = 0:
   i = x == 0;
   if any(i(:))
      y(i) = -Inf;
   end

   % Case when X = 1:
   i = x == 1;
   if any(i(:))
      y(i) = Inf;
   end
