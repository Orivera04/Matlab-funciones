function b = besselj(alpha,xx)
%BESSELJ Bessel functions of the first kind.
%	J = BESSELJ(ALPHA,X) computes Bessel functions of the first kind,
%	J_sub_alpha(X) for real, non-negative order ALPHA and argument X.
%	In general, both ALPHA and X may be vectors.  The output J is
%	an m-by-n matrix with m = length(X), n = length(ALPHA) and
%	    J(i,k) = J_sub_alpha(k)(X(i)).
%	The elements of X can be any nonnegative real values in any order.
%	For ALPHA, however, there are two important restrictions: the
%	increment in ALPHA must be one, i.e. ALPHA = alpha:1:alpha+n-1,
%	and the values must satisfy 0 <= alpha(k) <= 1000.
%
%	Examples:
%
%	    besselj(3:9,(10:.2:20)') generates the 51-by-7 table on page 400
%	    of Abramowitz and Stegun, "Handbook of Mathematical Functions."
%
%	    besselj(2/3:1:98/3,r) generates the fractional order Bessel
%	    functions used by the MathWorks Logo, the L-shaped membrane.
%	    J_sub_2/3(r) matches the singularity at the interior corner
%	    where the angle is pi/(2/3).
%
%	See also: BESSELY, BESSELI, BESSELK.

%   Acknowledgement:
%
%	This program is based on a Fortran program by W. J. Cody,
%	Applied Mathematics Division, Argonne National Laboratory, 
%	dated March 19, 1990.  Cody references earlier work by
%	David J. Sookne and F. W. J. Olver:
%
%	"A Note on Backward Recurrence Algorithms," Olver, F. W. J.,
%	and Sookne, D. J., Math. Comp. 26, 1972, pp 941-947.
%
%	"Bessel Functions of Real Argument and Integer Order,"
%	Sookne, D. J., NBS Jour. of Res. B. 77B, 1973, pp 125-132.
%
%	Note:
%
%	This version supercedes earlier versions described in the reference
%	manuals for MATLAB 3.5 and 4.0.  Earlier usage is still acceptable,
%	but has been generalized to allow vector ALPHA.  The algorithm has
%	been substantially improved.  The auxilliary routines BESSELN and
%	BESSELA are not longer used.  BESSELH has been superceded by BESSELY.
%
%	MATLAB version: C. Moler, 10/2/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%
%  Check for real, non-negative arguments.
%
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
%  Two-term ascending series for small x.
%
   v = find(xx < 1.e-4);
   if any(v)
      x = xx(v);
      tempa = ones(size(x));
      alpem = 1 + alpha;
      halfx = 0.5*x;
      if (alpha ~= 0)
         tempa = halfx.^alpha/(alpha*gamma(alpha));
      end
      tempb = -halfx.*halfx;
      b(v,1) = tempa + tempa.*tempb/alpem;
      if (nb ~= 1)
%
%        Calculate higher order functions.
%
         tempc = halfx;
         for n = 2:nb
            tempa = tempa/alpem;
            alpem = alpem + 1;
            tempa = tempa.*tempc;
            b(v,n) = tempa + tempa.*tempb/alpem;
         end
      end
   end
%
%  Aymptotic series for large x when nb is not too large.
%
   v = find((xx > 25) & (nb <= xx+1));
   if any(v)
      x = xx(v);
      xc = sqrt(2./(pi*x));
      xin = (1./(8*x)).^2;
      m = 11;
      if all(x >= 35), m = 8; end
      if all(x >= 130), m = 4; end
      xm = 4*m;
%
%     Argument reduction for sin and cos routines.
%     twopi1 + twopi2 = 2 * pi to extra precision.
%
      twopi1 = 201/32;
      twopi2 = 0.001935307179586476925286767;
      t = round(x/(2*pi));
      z = (x-t*twopi1) - t*twopi2 - (alpha+0.5)*pi/2;
      vsin = sin(z);
      vcos = cos(z);
      gnu = alpha + alpha;
      for i = 1:2
         s = ((xm-1)-gnu)*((xm-1)+gnu)*xin*0.5;
         t = (gnu-(xm-3)).*(gnu+(xm-3));
         capp = s.*t/prod(1:2*m);
         t1 = (gnu-(xm+1)).*(gnu+(xm+1));
         capq = s.*t1/prod(1:2*m+1);
         xk = xm;
         k = m + m;
         t1 = t;
         for j = 2:m
            xk = xk - 4;
            s = ((xk-1)-gnu).*((xk-1)+gnu);
            t = (gnu-(xk-3)).*(gnu+(xk-3));
            capp = (capp+1/prod(1:k-2)).*s.*t.*xin;
            capq = (capq+1/prod(1:k-1)).*s.*t1.*xin;
            k = k - 2;
            t1 = t;
         end
         capp = capp + 1;
         capq = (capq+1).*(gnu*gnu-1).*(1./(8*x));
         b(v,i) = xc.*(capp.*vcos-capq.*vsin);
         if (nb == 1), break, end
         t = vsin;
         vsin = -vcos;
         vcos = t;
         gnu = gnu + 2;
      end
%
      gnu = alpha + alpha + 2;
      for j = 3:nb
         b(v,j) = gnu*b(v,j-1)./x - b(v,j-2);
         gnu = gnu + 2;
      end
   end
%
%  For most x, use three-term recurrence.
%
   v = find((xx >= 1.e-4) & ((xx <= 25) | (nb > xx+1)));
   if any(v)
      x = xx(v);
      ncalc = 0;
      magx = max(x);
      nbmx = nb - floor(magx);
      n = floor(magx) + 1;
      en = n+n + (alpha+alpha);
      plast = 1;
      p = en/magx;
%
%     Calculate general significance test.
%
      test = 2/eps;
      if (nbmx >= 3)
%
%     Calculate p*s until n = nb-1.  Check for possible overflow.
%
         tover = eps*realmax;
         nstart = floor(magx) + 2;
         nend = nb - 1;
         en = nstart+nstart - 2 + (alpha+alpha);
         for k = nstart:nend
            n = k;
            en = en + 2;
            pold = plast;
            plast = p;
            p = en*plast/magx - pold;
            if p > tover
%
%           To avoid overflow, divide p*s by tover.
%           Calculate p*s until abs(p) > 1.
%
               tover = realmax;
               p = p/tover;
               plast = plast/tover;
               psave = p;
               psavel = plast;
               nstart = n + 1;
               while p <= 1
                  n = n + 1;
                  en = en + 2;
                  pold = plast;
                  plast = p;
                  p = en*plast/magx - pold;
               end
               tempb = en/magx;
%
%              Calculate backward test and find ncalc, the highest n
%              such that the test is passed.
%
               test = pold*plast*(0.5-0.5/(tempb*tempb));
               test = eps*test;
               p = plast*tover;
               n = n - 1;
               en = en - 2;
               nend = min(nb,n);
               ncalc = nend;
               for l = nstart:nend
                  pold = psavel;
                  psavel = psave;
                  psave = en*psavel/magx - pold;
                  if psave*psavel > test
                     ncalc = l - 1;
                     break
                  end
               end
               break
            end
         end
         if ncalc == 0
            n = nend;
            en = n+n + (alpha+alpha);
%
%           Calculate special significance test for nbmx > 2.
%
            test = max(test,max(sqrt(plast/eps)*sqrt(p+p)));
         end
      end
%
%     Calculate p*s until significance test passes.
%
      if ncalc == 0
         ncalc = nb;
         while p < test
            n = n + 1;
            en = en + 2;
            pold = plast;
            plast = p;
            p = en*plast/magx - pold;
         end
      end
%
%     Initialize the backward recursion and the normalization sum.
%
      n = n + 1;
      en = en + 2;
      tempb = zeros(size(x));
      tempa = ones(size(x))/p;
      m = 2*n - 4*fix(n/2);
      sum = zeros(size(x));
      em = fix(n/2);
      alpem = (em-1) + alpha;
      alp2em = (em+em) + alpha;
      if (m ~= 0), sum = tempa*alpem*alp2em/em; end
      nend = n - nb;
      if (nend > 0)
%
%     Recur backward via difference equation, calculating (but not
%     storing) b(:,n), until n = nb.
%
         for l = 1:nend
            n = n - 1;
            en = en - 2;
            tempc = tempb;
            tempb = tempa;
            tempa = (en*tempb)./x - tempc;
            m = 2 - m;
            if (m ~= 0) 
               em = em - 1;
               alp2em = (em+em) + alpha;
               if (n == 1), break, end
               alpem = (em-1) + alpha;
               if (alpem == 0), alpem = 1; end
               sum = (sum+tempa*alp2em)*alpem/em;
            end
         end
      end
%
%     Store b(:,nb).
%
      b(v,n) = tempa;
      if (nend >= 0)
         if (nb <= 1)
            alp2em = alpha;
            if ((alpha+1) == 1), alp2em = 1; end
            sum = sum + b(v,1)*alp2em;
         else
%
%        Calculate and store b(:,nb-1).
%
            n = n - 1;
            en = en - 2;
            b(v,n) = (en*tempa)./x - tempb;
            if (n == 1)
               m = 2;
            end
            m = 2 - m;
            if (m ~= 0)
               em = em - 1;
               alp2em = (em+em) + alpha;
               alpem = (em-1) + alpha;
               if (alpem == 0), alpem = 1; end
               sum = (sum+b(v,n)*alp2em)*alpem/em;
            end
         end
      end
      nend = n - 2;
      if (nend > 0)
%
%     Calculate via difference equation and store b(:,n), until n = 2.
%
         for l = 1:nend
            n = n - 1;
            en = en - 2;
            b(v,n) = (en*b(v,n+1))./x - b(v,n+2);
            m = 2 - m;
            if (m ~= 0)
               em = em - 1;
               alp2em = (em+em) + alpha;
               alpem = (em-1) + alpha;
               if (alpem == 0), alpem = 1; end
               sum = (sum+b(v,n)*alp2em)*alpem/em;
            end
         end
      end
%
%     Calculate b(:,1), i necessary.
%
      if nb > 1, 
         if n > 1
            b(v,1) = 2*(alpha+1)*b(v,2)./x - b(v,3);
         end
         em = em - 1;
         alp2em = (em+em) + alpha;
         if (alp2em == 0), alp2em = 1; end
         sum = sum + b(v,1)*alp2em;
      end
%
%     Normalize.  Divide all b(:,n) by sum.
%
      if alpha > eps
         sum = gamma(alpha)*sum.*(x*0.5).^(-alpha);
      end
      for n = 1:nb
         b(v,n) = b(v,n)./sum;
      end
   end
%
%  Return the requested index range
%
   b = b(:,nfirst+1:nb);
   if resize
      b = reshape(b,resize(1),resize(2));
   end
