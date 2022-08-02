function x = ilogit(y)
%ILOGIT The inverse logit transformation.
%
%   The inverse tranformation maps the whole real line to the interval (0,1).
%   The tranformation is X = EXP(Y) / (1 + EXP(Y)).
%
%   See also LOGIT.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:30:15 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   t = exp(y);
   x = t ./ (1+t);

   k = isinf(y);
   if any(k(:))
      x(k) = y(k) > 0;
   end
