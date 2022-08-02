function b = besseli(alpha,xx,scale)
%BESSELI Modified Bessel functions of the first kind.
%	I = BESSELI(ALPHA,X) computes modified Bessel functions of the
%	first kind, I_sub_alpha(X) for real, non-negative order ALPHA
%	and argument X.  In general, both ALPHA and X may be vectors.
%	The output I is m-by-n with m = length(X), n = length(ALPHA) and
%	    I(k,j) = I_sub_alpha(j)(X(k)).
%	The elements of X can be any nonnegative real values in any order.
%	For ALPHA there are two important restrictions: the increment
%	in ALPHA must be one, i.e. ALPHA = alpha:1:alpha+n-1, and the
%	elements must also be in the range 0 <= ALPHA(j) <= 1000.
%
%	E = BESSELI(ALPHA,X,1) computes I_sub_alpha(X)*EXP(-X).
%
%	The relationship between the Bessel functions of the first kind is
%
%	    I_sub_alpha(x) = i^(-alpha) * J_sub_alpha(i*x)
%
%	Examples:
%
%	    besseli(3:9,[0:.2:9.8 10:.5:20],1) generates the entire 
%	    71-by-7 table on page 423 of Abramowitz and Stegun,
%	    "Handbook of Mathematical Functions."
%
%	See also: BESSELJ, BESSELY, BESSELK.

%   Acknowledgement:
%
%	This program is based on a Fortran program by W. J. Cody and
%	L. Stoltz, Applied Mathematics Division, Argonne National
%	Laboratory, dated May 30, 1989.  Their references include:
%
%	   "A Note on backward recurrence algorithms," Olver, F. W. J.,
%	   and Sookne, D. J., Math. Comp. 26, 1972, pp 941-947.
%
%	   "Bessel functions of real argument and integer order,"
%	   Sookne, D. J., NBS Jour. of Res. B. 77b, 1973, pp. 125-132.
%
%	   "Algorithm 597, Sequence of modified Bessel functions of the
%	   "first kind," Cody, W. J., Trans. Math. Soft., 1983, pp. 242-245.
%
%	MATLAB version: C. Moler, 10/6/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%
%  Check for real, non-negative arguments.
%
   if nargin < 3, scale = 0; end
   if any(imag(xx)) | any(xx < 0) | any(imag(alpha)) | any(alpha < 0)
      error('Input arguments must be real and nonnegative.')
   end
   if isempty(alpha) | isempty(xx)
      bk = []; 
      return
   end
%
%  Break alpha into integer and fractional parts,
%  and initialize result array.
%
   nfirst = fix(alpha(1));
   nb = fix(alpha(length(alpha))) + 1;
   if ~(nb <= 1001)
      error('Alpha must be <= 1000.')
   end
   if length(alpha) > 1
      if any(abs(diff(alpha)-1) > 4*nb*eps)
         error('Increment in alpha must be 1.')
      end
   end
   resize = (length(alpha) == 1);
   if resize, resize = size(xx); end
   xx = xx(:);
   b = NaN*ones(length(xx),nb);
   alpha = alpha(1) - nfirst;
%
%  Asymptotic expansion for large x.
%
   v = find(1.e3 < xx);
   if any(v)
      x = xx(v);
      if scale
         z = 1./(8*x);
         mu = 4*(nfirst+alpha:1:nb-1+alpha).^2;
         z = (1 - z*(mu-1).*(1 - (z/2)*(mu-9).*(1 - (z/3)*(mu - 25))));
         b(v,nfirst+1:nb) = ((1./sqrt(2*pi*x))*ones(1,nb-nfirst)).*z;
      else
         b(v,:) = Inf*ones(length(v),nb);
      end
   end
%
%  Three-term backward recurrence for most x.
%
   v = find((1.e-4 <= xx) & (xx <= 1.e3));
   if any(v)
      x = xx(v);
      magx = max(fix(x));
%
%     Initialize the forward sweep, the p-sequence of Olver.
%
      nbmx = nb-magx;
      n = magx+1;
      en = (n+n) + (alpha+alpha);
      plast = 1;
      p = en ./ x;
%
%     Calculate general significance test.
%
      test = 2/eps;
      if (2*magx > 80);
         test = sqrt(test*max(p));
      else
         test = test / 1.585^magx;
      end
      if (nbmx >= 3)
%
%     Calculate p-sequence until n = nb-1.
%
         tover = eps*realmax;
         nstart = magx+2;
         nend = nb - 1;
         for k = nstart:nend
            n = k;
            en = en + 2;
            pold = plast;
            plast = p;
            p = en * plast./x + pold;
            if any(p > tover)
%
%           To avoid overflow, divide p-sequence by tover.
%           Calculate p-sequence until abs(p) > 1.
%
               tover = realmax;
               p = p / tover;
               plast = plast / tover;
               psave = p;
               psavel = plast;
               nstart = n + 1;
               while any(p <= 1);
                  n = n + 1;
                  en = en + 2;
                  pold = plast;
                  plast = p;
                  p = en * plast./x + pold;
               end
               tempb = en ./ x;
%
%              Calculate backward test, and find ncalc,
%              the highest n such that the test is passed.
%
               test = pold*plast*eps;
               test = test*(0.5-0.5/min(tempb*tempb));
               p = plast * tover;
               n = n - 1;
               en = en - 2;
               nend = min(nb,n);
               ncalc = nend + 1;
               for l = nstart:nend
                  pold = psavel;
                  psavel = psave;
                  psave = en * psavel./x + pold;
                  if any(psave.*psavel > test);
                     ncalc = l-1;
                     test = 0;
                     break
                  end
               end
               break
            end
         end
         if ~test
            n = nend;
            en = (n+n) + (alpha+alpha);
%
%           Calculate special significance test for nbmx > 2.
%
            test = max(test,max(sqrt(plast/eps).*sqrt(p+p)));
         end
      end
%
%     Calculate p-sequence until significance test passed.
%
      while any(p < test)
         n = n + 1;
         en = en + 2;
         pold = plast;
         plast = p;
         p = en * plast./x + pold;
      end
%
%     Initialize the backward recursion and the normalization sum.
%
      n = n + 1;
      en = en + 2;
      tempb = 0;
      tempa = 1 ./ p;
      em = n - 1;
      empal = em + alpha;
      emp2al = (em - 1) + (alpha + alpha);
      sum = tempa * empal * emp2al / em;
      nend = n - nb;
      skip = 0;
      if (nend < 0)
         b(v,n) = tempa;
         nend = -nend;
         b(v,n+1:n+nend) = zeros(length(v),nend);
      else
         if (nend > 0)
%
%           Recur backward via difference equation, calculating 
%           (but not storing) b(n), until n = nb.
%
            for l = 1:nend
               n = n - 1;
               en = en - 2;
               tempc = tempb;
               tempb = tempa;
               tempa = (en*tempb) ./ x + tempc;
               em = em - 1;
               emp2al = emp2al - 1;
               if (n == 1), break, end
               if (n == 2), emp2al = 1; end
               empal = empal - 1;
               sum = (sum + tempa*empal) * emp2al / em;
            end
         end
%
%        Store b(nb).
%
         b(v,n) = tempa;
         if (nb <= 1)
            sum = (sum + sum) + tempa;
            skip = -1;
         else
%
%           Calculate and store b(nb-1).
%
            n = n - 1;
            en = en - 2;
            b(v,n)  = (en*tempa) ./ x + tempb;
            if (n == 1)
               skip = 1;
            else
               em = em - 1;
               emp2al = emp2al - 1;
               if (n == 2), emp2al = 1; end
               empal = empal - 1;
               sum = (sum + b(v,n)*empal) * emp2al / em;
            end
         end
      end
      if skip == 0
         nend = n - 2;
         if (nend > 0)
%
%        Calculate via difference equation and store b(n), until n = 2.
%
            for l = 1:nend
               n = n - 1;
               en = en - 2;
               b(v,n) = (en*b(v,n+1)) ./ x + b(v,n+2);
               em = em - 1;
               emp2al = emp2al - 1;
               if (n == 2), emp2al = 1; end
               empal = empal - 1;
               sum = (sum + b(v,n)*empal) * emp2al / em;
            end
         end
      end
%
%     Calculate b(1)
%
      if skip == 0, b(v,1) = 2*empal*b(v,2) ./ x + b(v,3); end
      if skip >= 0, sum = (sum + sum) + b(v,1); end
%
%     Normalize.  Divide all b(n) by sum.
%
      if (alpha ~= 0)
         sum = sum * gamma(1+alpha) .* (x*0.5).^(-alpha);
      end
      if ~scale, sum = sum .* exp(-x); end
      for n = 1:nb
         b(v,n) = b(v,n) ./ sum;
      end
   end
%
%  Two-term ascending series for small x.
%
   v = find((0 < xx) & (xx < 1.e-4));
   if any(v)
      x = xx(v);
      tempa = ones(length(x),1);
      empal = 1 + alpha;
      halfx = 0.5 * x;
      if (alpha ~= 0),  tempa = halfx.^alpha /gamma(empal); end
      if scale, tempa = tempa .* exp(-x); end
      tempb = halfx .* halfx;
      b(v,1) = tempa + tempa.*tempb / empal;
      if (nb > 1)
%
%        Calculate higher-order functions.
%
         tempc = halfx;
         tover = 8*realmin ./ x;
         for n = 2:nb;
            tempa = tempa / empal;
            empal = empal + 1;
            tempa = tempa .* tempc;
            tempa = tempa .* (tempa > tover*empal);
            b(v,n) = tempa + tempa.*tempb / empal;
         end
      end
   end
%
%  x == 0
%
   v = find(xx == 0);
   if any(v)
      % if alpha>0, I(alpha,0) = 0; I(0,0) = 1.
      b(v,:) = zeros(length(v),nb);
      if alpha == 0, b(v,1) = ones(length(v),1); end
   end
%
%  Return the requested index range
%
   b = b(:,nfirst+1:nb);
   if resize
      b = reshape(b,resize(1),resize(2));
   end
