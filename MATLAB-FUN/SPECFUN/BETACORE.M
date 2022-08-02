function y = betacore(x, a, b)
%BETACORE Core algorithm for the incomplete beta function.
%	BETACORE(x,a,b) is used twice by BETAINC(X,A,B).
%
%	See also BETAINC.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = x;
qab = a + b;
qap = a + 1;
qam = a - 1;
am = ones(size(x));
bm = am;
y = am;
bz = 1 - qab .* x ./ qap;
d = zeros(size(x));
app = d;
ap = d;
bpp = d;
bp = d;
yold = d;
m = 1;
while any(any(abs(y-yold) > 4*eps*abs(y)))
   tem = 2 * m;
   d = m * (b - m) .* x ./ ((qam + tem) .* (a + tem));
   ap = y + d .* am;
   bp = bz + d .* bm;
   d = -(a + m) .* (qab + m) .* x ./ ((a + tem) .* (qap + tem));
   app = ap + d .* y;
   bpp = bp + d .* bz;
   yold = y;
   am = ap ./ bpp;
   bm = bp ./ bpp;
   y = app ./ bpp;
   if m == 1
      bz = 1;   % only need to do this first time through
   end
   m = m + 1;
end
