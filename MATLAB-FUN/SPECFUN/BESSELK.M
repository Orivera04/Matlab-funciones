function bk = besselk(alpha,xx,scale)
%BESSELK Modified Bessel functions of the second kind.
%	K = BESSELK(ALPHA,X) computes modified Bessel functions of the
%	second kind, K_sub_alpha(X) for real, non-negative order ALPHA
%	and argument X.  In general, both ALPHA and X may be vectors.
%	The output I is m-by-n with m = lenth(X), n = length(ALPHA) and
%	    I(k,j) = I_sub_alpha(j)(X(k)).
%	The elements of X can be any nonnegative real values in any order.
%	For ALPHA there are two important restrictions: the increment
%	in ALPHA must be one, i.e. ALPHA = alpha:1:alpha+n-1, and the
%	elements must also be in the range 0 <= ALPHA(j) <= 1000.
%
%	E = BESSELK(ALPHA,X,1) computes K_sub_alpha(X)*EXP(X).
%
%	The relationship to unmodified Bessel functions with imaginary 
%	argument:
%
%	    K_sub_alpha(x) = pi/2 * i^(-alpha) * (J_sub_alpha(i*x) +
%	                     Y_sub_alpha(i*x))
%
%	Examples:
%
%	    besselk(3:9,[0:.2:9.8 10:.5:20],1) generates the entire 
%	    71-by-7 table on page 424 of Abramowitz and Stegun,
%	    "Handbook of Mathematical Functions."
%
%	See also: BESSELJ, BESSELY, BESSELI.

%   Acknowledgement:
%
%	This program is based on a Fortran program by W. J. Cody and
%	L. Stoltz, Applied Mathematics Division, Argonne National
%	Laboratory, dated May 30, 1989.  Their references include:
%
%	    "On Temme's algorithm for the modified Bessel functions of the
%	    third kind," Campbell, J. B., TOMS 6(4), Dec. 1980, pp. 581-586.
%
%	    "A Fortran IV Subroutine for the modified Bessel functions of
%	    the third kind of real order and real argument," Campbell, J. B.,
%	    Report NRC/ERB-925, National Research Council, Canada.
%
%	MATLAB version: C. Moler, 10/9/92.
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
   resize = (length(alpha)==1);
   if resize, resize = size(xx); end
   xx = xx(:);
   bk = NaN*ones(length(xx),nb);
   alpha = alpha(1) - nfirst;
%
%  ln2mgamma = log(2) - Euler's constant
%  p, q - approximation for log(gamma(1+alpha))/alpha
%                                         + Euler's constant
%  r, s - approximation for (1-alpha*pi/sin(alpha*pi))/(2.d0*alpha)
%  t    - approximation for sinh(y)/y

   ln2mgamma = 0.11593151565841244881;
   p = [0.805629875690432845e00, 0.204045500205365151e02, ...
        0.157705605106676174e03, 0.536671116469207504e03, ...
        0.900382759291288778e03, 0.730923886650660393e03, ...
        0.229299301509425145e03, 0.822467033424113231e00];
   q = [0.294601986247850434e02, 0.277577868510221208e03, ...
        0.120670325591027438e04, 0.276291444159791519e04, ...
        0.344374050506564618e04, 0.221063190113378647e04, ...
        0.572267338359892221e03];
   r = [-0.48672575865218401848e+0, 0.13079485869097804016e+2, ...
        -0.10196490580880537526e+3, 0.34765409106507813131e+3, ...
         0.34958981245219347820e-3];
   s = [-0.25579105509976461286e+2, 0.21257260432226544008e+3, ...
        -0.61069018684944109624e+3, 0.42269668805777760407e+3];
   t = [ 0.16125990452916363814e-9, 0.25051878502858255354e-7, ...
         0.27557319615147964774e-5, 0.19841269840928373686e-3, ...
         0.83333333333334751799e-2, 0.16666666666666666446e+0];
%
%  This algorithm can not be conveniently vectorized in x.
%  So, we do it the hard way.
%
   for v = 1:length(xx)
      x = xx(v);
      enu = alpha;
      ncalc = 0;
      k = 0;
      if (enu < sqrt(realmin)), enu = 0; end
      if (enu > 0.5);
            k = 1;
            enu = enu - 1;
      end
      twonu = enu+enu;
      iend = nb+k-1;
      c = enu*enu;
      d3 = -c;
      if (x == 0)
         bk(v,:) = Inf*ones(1,nb);
         ncalc = nb;
      elseif (x <= 1);
%
%        Calculation of p0 = gamma(1+alpha) * (2/x)^alpha
%                       q0 = gamma(1-alpha) * (x/2)^alpha
%
         d1 = 0;
         d2 = p(1);
         t1 = 1;
         t2 = q(1);
         for i = 2:2:7;
            d1 = c*d1+p(i);
            d2 = c*d2+p(i+1);
            t1 = c*t1+q(i);
            t2 = c*t2+q(i+1);
         end
         d1 = enu*d1;
         t1 = enu*t1;
         f1 = log(x);
         f0 = ln2mgamma+enu*(p(8)-enu*(d1+d2)/(t1+t2))-f1;
         q0 = exp(-enu*(ln2mgamma-enu*(p(8)+enu*(d1-d2)/(t1-t2))-f1));
         f1 = enu*f0;
         p0 = exp(f1);
         d1 = r(5);
         t1 = 1;
         for i = 1:4;
            d1 = c*d1+r(i);
            t1 = c*t1+s(i);
         end
         if (abs(f1) <= 0.5)
            f1 = f1*f1;
            d2 = 0;
            for i = 1:6;
               d2 = f1*d2+t(i);
            end
            d2 = f0+f0*f1*d2;
         else
            d2 = sinh(f1)/enu;
         end
         f0 = d2-enu*d1/(t1*p0);
         if (x <= 1.e-10)
%
%        Calculation of K(alpha,x) and x*K(alpha+1,x)/K(alpha,x)
%
            bk(v,1) = f0+x*f0;
            if (~scale), bk(v,1) = bk(v,1)-x*bk(v,1); end
            ratio = p0/f0;
            if (k ~= 0)
%
%            Calculation of K(alpha,x) and x*K(alpha+1,x)/K(alpha,x),
%            alpha >= 1/2
%
               bk(v,1) = ratio*bk(v,1)/x;
               twonu = twonu+2;
               ratio = twonu;
            end
            if (nb == 1)
               ncalc = 1;
            end
%
%           Calculate  K(alpha+l,x)/K(alpha+l-1,x), l = 1,:nb-1
%
            for i = 2:nb;
               bk(v,i) = ratio/x;
               twonu = twonu+2;
               ratio = twonu;
            end
            ncalc = 1;
         else
%
%        1.0e-10 < x <= 1.0
%
            c = 1;
            x2by4 = x*x/4;
            p0 = 0.5*p0;
            q0 = 0.5*q0;
            d1 = -1;
            d2 = 0;
            bk1 = 0;
            bk2 = 0;
            f1 = f0;
            f2 = p0;
            t1 = inf;
            t2 = inf;
            while ((abs(t1/(f1+bk1))>eps) | (abs(t2/(f2+bk2))>eps)) ;
               d1 = d1+2;
               d2 = d2+1;
               d3 = d1+d3;
               c = x2by4*c/d2;
               f0 = (d2*f0+p0+q0)/d3;
               p0 = p0/(d2-enu);
               q0 = q0/(d2+enu);
               t1 = c*f0;
               t2 = c*(p0-d2*f0);
               bk1 = bk1+t1;
               bk2 = bk2+t2;
            end
            bk1 = f1+bk1;
            bk2 = 2*(f2+bk2)/x;
            if scale
                  d1 = exp(x);
                  bk1 = bk1*d1;
                  bk2 = bk2*d1;
            end
            wminf = 41.8341*x+7.1075;
         end
      elseif (eps*x > 1);
%
%        1/eps < x
%
         bk1 = sqrt(2/(pi*x));
         for i = 1:nb;
            bk(v,i) = bk1;
         end
         ncalc = nb;
      else
%
%        1.0 < x <= 1/eps
%
         twox = x+x;
         blpha = 0;
         ratio = 0;
         if (x <= 4)
%
%        Calculation of K(alpha+1,x)/K(alpha,x),  1.0 <= x <= 4.0
%
            d2 = fix(52.0583/x+5.7607);
            m = d2;
            d1 = d2+d2;
            d2 = d2-0.5;
            d2 = d2*d2;
            for i = 2:m;
               d1 = d1-2;
               d2 = d2-d1;
               ratio = (d3+d2)/(twox+d1-ratio);
            end
%
%           Calculation of I(alpha,x) and I(alpha+1,x) by backward
%           recurrence and K(alpha,x) from the Wronskian
%
            d2 = fix(2.7782*x+14.4303);
            m = d2;
            c = abs(enu);
            d3 = c+c;
            d1 = d3-1;
            f1 = realmin;
            f0 = (2*(c+d2)/x+0.5*x/(c+d2+1))*realmin;
            for i = 3:m;
               d2 = d2-1;
               f2 = (d3+d2+d2)*f0;
               blpha = (1+d1/d2)*(f2+blpha);
               f2 = f2/x+f1;
               f1 = f0;
               f0 = f2;
            end
            f1 = (d3+2)*f0/x+f1;
            d1 = 0;
            t1 = 1;
            for i = 1:7;
               d1 = c*d1+p(i);
               t1 = c*t1+q(i);
            end
            p0 = exp(c*(ln2mgamma+c*(p(8)-c*d1/t1)-log(x)))/x;
            f2 = (c+0.5-ratio)*f1/x;
            bk1 = p0+(d3*f0-f2+f0+blpha)/(f2+f1+f0)*p0;
            if (~scale), bk1 = bk1*exp(-x); end
            wminf = 6.4306*x+42.511;
         else
%
%        Calculation of K(alpha,x) and K(alpha+1,x)/K(alpha,x)
%        by backward recurrence, for x > 4.0
%
            dm = fix(185.3004/x+9.3715);
            m = dm;
            d2 = dm-0.5;
            d2 = d2*d2;
            d1 = dm+dm;
            for i = 2:m;
               dm = dm-1;
               d1 = d1-2;
               d2 = d2-d1;
               ratio = (d3+d2)/(twox+d1-ratio);
               blpha = (ratio+ratio*blpha)/dm;
            end
            d = sqrt(2/pi);
            bk1 = 1/((d+d*blpha)*sqrt(x));
            if (~scale), bk1 = bk1*exp(-x); end
            wminf = 1.35633*(x-abs(x-20))+84.5096;
         end
%
%        Calculation of K(alpha+1,x) from K(alpha,x) and
%        K(alpha+1,x)/K(alpha,x)
%
         bk2 = bk1+bk1*(enu+0.5-ratio)/x;
      end
      if ~ncalc
%
%        Calculation of ncalc, K(alpha+i,x), i = 0:ncalc-1,
%        K(alpha+i,x)/K(alpha+i-1,x), i = ncalc:nb-1
%
         ncalc = nb;
         bk(v,1) = bk1;
         if (iend > 0)
            j = 2-k;
            if (j > 0), bk(v,j) = bk2; end
            if (iend > 1)
               m = iend;
               if wminf-enu < m, m = fix(wminf-enu); end
               for i = 2:m;
                  t1 = bk1;
                  bk1 = bk2;
                  twonu = twonu+2;
                  bk2 = twonu/x*bk1+t1;
                  itemp = i;
                  j = j+1;
                  if (j > 0), bk(v,j) = bk2; end
               end
               m = itemp;
               if (m ~= iend)
                  ratio = bk2/bk1;
                  mplus1 = m+1;
                  for i = mplus1:iend;
                     twonu = twonu+2;
                     ratio = twonu/x+1/ratio;
                     j = j+1;
                     if (j > 1)
                           bk(v,j) = ratio;
                        else
                           bk2 = ratio*bk2;
                     end
                  end
                  ncalc = max(mplus1-k,1);
                  if (ncalc == 1), bk(v,1) = bk2; end
               end
            end
         end
      end
      for i = ncalc+1:nb
         bk(v,i) = bk(v,i-1)*bk(v,i);
      end   
   end
%
%  Return the requested index range
%
   bk = bk(:,nfirst+1:nb);
   if resize
      bk = reshape(bk,resize(1),resize(2));
   end
