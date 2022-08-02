function y = bessely(alpha,xx)
%BESSELY Bessel functions of the second kind.
%	Y = BESSELY(ALPHA,X) calculates Bessel functions of the second kind,
%	Y_sub_alpha(X) for real, non-negative order ALPHA and argument X.
%	In general, both ALPHA and X may be vectors.  The output Y is
%	an m-y-n matrix with m = lenth(X), n = length(ALPHA) and
%	    Y(i,k) = Y_sub_alpha(k)(X(i)).
%	The elements of X can be any nonnegative real values in any order.
%	For ALPHA, however, there are two important restrictions: the
%	increment in ALPHA must be one, i.e. ALPHA = alpha:1:alpha+n-1,
%	and the values must satisfy 0 <= alpha(k) <= 1000.
%
%	Examples:
%
%	    bessely(3:9,(10:.2:20)') generates the 51-by-7 table on page 401
%	    of Abramowitz and Stegun, "Handbook of Mathematical Functions."
%
%	See also: BESSELJ, BESSELI, BESSELK.

%   Acknowledgement:
%
%	This program is based on a Fortran program by W. J. Cody,
%	Applied Mathematics Division, Argonne National Laboratory, 
%	dated March 19, 1990.  Cody references earlier work by
%	N. M. Temme and J. B. Campbell.
%
%	References: "Bessel functions J_nu(x) and Y_nu(x) of real
%	   order and real argument," Campbell, J. B.,
%	   Comp. Phy. Comm. 18, 1979, pp. 133-142.
%
%	   "On the numerical evaluation of the ordinary
%	   Bessel function of the second kind," Temme,
%	   N. M., J. Comput. Phys. 21, 1976, pp. 343-350.
%
%	MATLAB version: C. Moler, 10/2/92, 12/11/92, 12/8/93.
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
   zz = (xx==0);  % Remember location of x == 0.
   if any(zz), xx = xx + zz; end
   y = NaN*ones(length(xx),nb);
   y0 = NaN*ones(length(xx),1);
   y1 = NaN*ones(length(xx),1);
   alpha = alpha(1) - nfirst;
%
   enu = alpha;
   na = round(enu);
   if (na == 1), enu = enu - na; end
   if (enu == -0.5)
      p = sqrt(2./(pi*xx));
      y0 = p .* sin(xx);
      y1 = -p .* cos(xx);
   else
%
%     Use Temme's scheme for small x.
%
      v = find(xx < 3);
      if any(v)
         x = xx(v);
         b = x * 0.5;
         d = -log(b);
         f = enu * d;
         e = b.^(-enu);
         if (abs(enu) < 1.e-8)
            c = 1/pi;
         else
            c = enu / sin(enu*pi);
         end
%
%        Computation of sinh(f)/f
%
         if any(abs(f) < 1)
            x2 = f.*f;
            en = 19;
            s = 1;
            for i = 1:9
               s = s.*x2/en/(en-1)+1;
               en = en - 2;
            end
         else
            s = (e - 1./e) * 0.5 ./ f;
         end
%
%        Computation of 1/gamma(1-a) using Chebyshev polynomials.
%
         ch = [-0.67735241822398840964d-23,-0.61455180116049879894d-22, ...
                0.29017595056104745456d-20, 0.13639417919073099464d-18, ...
                0.23826220476859635824d-17,-0.90642907957550702534d-17, ...
               -0.14943667065169001769d-14,-0.33919078305362211264d-13, ...
               -0.17023776642512729175d-12, 0.91609750938768647911d-11, ...
                0.24230957900482704055d-09, 0.17451364971382984243d-08, ...
               -0.33126119768180852711d-07,-0.86592079961391259661d-06, ...
               -0.49717367041957398581d-05, 0.76309597585908126618d-04, ...
                0.12719271366545622927d-02, 0.17063050710955562222d-02, ...
               -0.76852840844786673690d-01,-0.28387654227602353814d+00, ...
                0.92187029365045265648d+00];

         x2 = enu*enu*8;
         aye = ch(1);
         even = 0;
         alfa = ch(2);
         odd = 0;
         for i = 3:2:19
            even = -(aye+aye+even);
            aye = -even*x2 - aye + ch(i);
            odd = -(alfa+alfa+odd);
            alfa = -odd*x2 - alfa + ch(i+1);
         end
         even = (even*0.5+aye)*x2 - aye + ch(21);
         odd = (odd+alfa)*2;
         gamma = odd*enu + even;
%
%        End of computation of 1/gamma(1-a)
%
         g = e * gamma;
         e = (e + 1./e) * 0.5;
         f = 2*c*(odd.*e+even.*s.*d);
         e = enu*enu;
         p = g.*c;
         q = 1./(pi*g);
         c = enu*pi/2;
         if (abs(c) < 1.e-8)
            r = 1;
         else
            r = sin(c)/c;
         end
         r = pi*c*r*r;
         c = 1;
         d = -b.*b;
         h = zeros(size(x));
         y0(v) = f + r*q;
         y1(v) = p;
         en = 1;
         while (max(abs(g./(1+abs(y0(v)))) + abs(h./(1+abs(y1(v))))) > eps)
            f = (f*en+p+q)/(en*en-e);
            c = c.*d/en;
            p = p/(en-enu);
            q = q/(en+enu);
            g = c.*(f+r.*q);
            h = c.*p - en*g;
            y0(v) = y0(v) + g;
            y1(v) = y1(v) + h;
            en = en + 1;
         end
         y0(v) = -y0(v);
         y1(v) = -y1(v)./b;
      end
%
%     Use Temme's scheme for moderate x
%
      v = find((xx >= 3) & (xx < 16));
      if any(v)
         x = xx(v);
         c = (0.5-enu)*(0.5+enu);
         b = x + x;
         e = (x/pi*cos(enu*pi)/eps);
         e = e.*e;
         p = ones(size(x));
         q = -x;
         r = 1 + x.*x;
         s = r;
         en = 2;
         while any(r*en*en < e)
            en1 = en+1;
            d = (en-1+c/en)./s;
            p = (en+en-p.*d)/en1;
            q = (-b+q.*d)/en1;
            s = p.*p + q.*q;
            r = r.*s;
            en = en1;
         end
         f = p./s;
         p = f;
         g = -q./s;
         q = g;
         en = en - 1;
         while en > 0;
            r = en1*(2-p)-2;
            s = b + en1*q;
            d = (en-1+c/en)./(r.*r+s.*s);
            p = d.*r;
            q = d.*s;
            e = f + 1;
            f = p.*e - g.*q;
            g = q.*e + p.*g;
            en1 = en;
            en = en - 1;
         end
         f = 1 + f;
         d = f.*f + g.*g;
         pa = f./d;
         qa = -g./d;
         d = enu + 0.5 -p;
         q = q + x;
         pa1 = (pa.*q-qa.*d)./x;
         qa1 = (qa.*q+pa.*d)./x;
         b = x - (pi/2)*(enu+0.5);
         c = cos(b);
         s = sin(b);
         d = sqrt(2./(pi*x));
         y0(v) = d.*(pa.*s+qa.*c);
         y1(v) = d.*(qa1.*s-pa1.*c);
      end
%
%     Use Campbell's asymptotic scheme for large x.
%
      v = find(xx >= 16);
      if any(v)
         x = xx(v);
         d1 = fix(x/(5*pi));
         dmu = ((x-15*d1)-d1*(5*pi-15))-(alpha+0.5)*pi/2;
         sig = 1-2*rem(d1,2);
         cosmu = sig.*cos(dmu);
         sinmu = sig.*sin(dmu);
         ddiv = 8 * x;
         dmu = alpha;
         den = sqrt(x);
         for k = 1:2
            p = cosmu;
            cosmu = sinmu;
            sinmu = -p;
            d1 = (2*dmu-1)*(2*dmu+1);
            d2 = 0;
            div = ddiv;
            p = 0;
            q = 0;
            q0 = d1./div;
            term = q0;
            for i = 2:20
               d2 = d2 + 8;
               d1 = d1 - d2;
               div = div + ddiv;
               term = -term*d1./div;
               p = p + term;
               d2 = d2 + 8;
               d1 = d1 - d2;
               div = div + ddiv;
               term = term*d1./div;
               q = q + term;
               if (abs(term) <= eps), break, end
            end
            p = p + 1;
            q = q + q0;
            if (k == 1)
               y0(v) = sqrt(2/pi) * (p.*cosmu-q.*sinmu) ./ den;
            else
               y1(v) = sqrt(2/pi) * (p.*cosmu-q.*sinmu) ./ den;
            end
            dmu = dmu + 1;
         end
      end
   end
   if (na == 1)
      if (enu == -0.5)
         v = 1:length(xx);
      else
         v = find(xx < 16);
      end
      if any(v)
         h = 2*(enu+1)./xx(v);
         h = h.*y1(v) - y0(v);
         y0(v) = y1(v);
         y1(v) = h;
      end
   end
%
%  Now have first two Y's.
%  Use three-term forward recurrence for the rest.
%
   y(:,1) = y0;
   if nb > 1
      y(:,2) = y1;
      if nb > 2
         aye = 1 + alpha;
         twobyx = 2./xx;
         for i = 3:nb
            y(:,i) = twobyx.*aye.*y(:,i-1) - y(:,i-2);
            aye = aye + 1;
         end
      end
   end
%
%  Y(alpha,0) = -Inf.
%
   v = find(zz);
   if any(v)
      y(v,:) = -inf*ones(length(v),nb);
   end
%
%  Return the requested index range
%
   y = y(:,nfirst+1:nb);
   if resize
      y = reshape(y,resize(1),resize(2));
   end
