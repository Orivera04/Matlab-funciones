function b = gammainc(x,a)
%GAMMAINC The incomplete gamma function.
%	Y = GAMMAINC(X,A) evaluates the incomplete gamma function at all
%	the elements of X.  X must be real.  X and A must be the same size
%	except that a scalar argument functions as a constant matrix
%	the same size of the other argument.
%
%	gammainc(x,a) = (integral from 0 to x of t^(a-1) exp(-t) dt)/gamma(a)
%	Note that gammainc(x,a) approaches 1 as x approaches infinity.
%
%	See also GAMMA, GAMMALN.

%	C.R. Denham 6-9-88, C. B. Moler, 10-17-90, 11-4-92, BAJ 5-5-93.
%	Ref: Abramowitz & Stegun, Handbook of Mathemtical Functions, sec. 6.
%       
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if prod(size(x)) == 1 & prod(size(a)) ~= 1
   [m,n] = size(a);
   x = x(ones(m,1),ones(n,1));
end

b = x;
lngama = gammaln(a);

k = find(x == 0);
if any(k)
   b(k) = 0*k;
end

k = find((x ~= 0) & (x < a+1));
if any(k)
   if prod(size(a)) == 1
      % Series expansion for x < a+1
      ap = a;
      sum = ones(size(k))/a;
      del = sum;
      while norm(del,'inf') >= 10*eps*norm(sum,'inf')
         ap = ap + 1;
         del = x(k) .* del/ap;
         sum = sum + del;
      end
      b(k) = sum .* exp(-x(k) + a*log(x(k)) - lngama);
   else
      % Series expansion for x < a+1
      ap = a;
      sum = ones(size(k)) ./a(k);
      del = sum;
      while norm(del,'inf') >= 10*eps*norm(sum,'inf')
         ap = ap + 1;
         del = x(k) .* del./ap(k);
         sum = sum + del;
      end
      b(k) = sum .* exp(-x(k) + a(k) .*log(x(k)) - gammaln(a(k)));
   end
end

k = find(x >= a + 1);
if any(k)
   % Continued fraction for x >= a+1
   a0 = ones(size(k));
   a1 = x(k);
   b0 = zeros(size(k));
   b1 = a0;
   fac = 1;
   n = 1;
   g = b1;
   gold = b0;
   if prod(size(a)) == 1
      while norm(g-gold,'inf') >= 10*eps*norm(g,'inf');
         gold = g;
         ana = n - a;
         a0 = (a1 + a0*ana) .* fac;
         b0 = (b1 + b0*ana) .* fac;
         anf = n*fac;
         a1 = x(k) .* a0 + anf .* a1;
         b1 = x(k) .* b0 + anf .* b1;
         fac = 1 ./ a1;
         g = b1 .* fac;
         n = n+1;
         b(k) = 1 - exp(-x(k) + a*log(x(k)) - lngama) .* g;
      end
   else
      while norm(g-gold,'inf') >= 10*eps*norm(g,'inf');
        gold = g;
        ana = n - a(k);
        a0 = (a1 + a0 .*ana) .* fac;
        b0 = (b1 + b0 .*ana) .* fac;
        anf = n*fac;
        a1 = x(k) .* a0 + anf .* a1;
        b1 = x(k) .* b0 + anf .* b1;
        fac = 1 ./ a1;
        g = b1 .* fac;
        n = n+1;
        b(k) = 1 - exp(-x(k) + a(k) .* log(x(k)) - gammaln(a(k))) .* g;
      end
   end
end

