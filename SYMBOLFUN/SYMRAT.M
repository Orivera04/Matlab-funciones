function s = symrat(x)
%SYMRAT	Symbolic rational approximation.
%	SYMRAT(X), for a scalar X, is a string representation of an
%	integer, the ratio of two integers, the ratio of two integers
%	times 'pi' or an integer times a power of 2.  When the string
%	is evaluated with MATLAB floating point arithmetic, the result
%	reproduces X exactly.
%
%	Examples: symrat(22/7)     = '22/7'
%	          symrat(2*pi/3)   = '2*pi/3'
%	          symrat(1.e12)    = '100000000000'
%	          symrat(eps)      = '2^(-52)'

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/24 22:37:18 $

if isstr(x)
   s = x;
elseif prod(size(x)) > 1
   s = sym(x);
elseif imag(x) > 0
   s = [symrat(real(x)) '+' symrat(imag(x)) '*i'];
elseif imag(x) < 0
   s = [symrat(real(x)) '-' symrat(abs(imag(x))) '*i'];
elseif isinf(x)
   if x > 0
      s = 'Inf';
   else
      s = '-Inf';
   end
elseif isnan(x)
   s = 'NaN';
else

   % Not-too-big integer.

   if x == fix(x) & abs(x) < 1/eps
      s = int2str(x);
      return
   end

   % Ratio of two modest integers.

   tol = abs(x)*eps;
   [n,d] = rat(x,tol);
   if n ~= 0 & abs(n) <= 10000 & d <= 10000
      if n/d == x
         s = [int2str(n) '/' int2str(d)];
         return
      end
   end

   % pi times ratio of two modest integers.

   [p,q] = rat(x/pi,tol);
   if p ~= 0 & abs(p) <= 10000 & q <= 10000
      if p*pi/q == x
         if p == 1
            s = 'pi'; 
         elseif p == -1
            s = '-pi';
         else
            s = [int2str(p) '*pi'];
         end
         if q ~= 1
            s = [s '/' int2str(q)];
         end
         return
      end
   end

   % None of the above.
   % Extract floating point fraction and exponent.

   [f,e] = log2(x);
   f = pow2(f,52);
   e = e-52;
   f2 = pow2(f,-1);
   while f2 == fix(f2)
      f = f2;
      e = e+1;
      f2 = pow2(f,-1);
   end
   if f == 1
      s = [];
   elseif f == -1
      s = '-';
   else
      s = [int2str(f) '*'];
   end
   if e > 0
      s = [s '2^' int2str(e)];
   else
      s = [s '2^(' int2str(e) ')'];
   end
end
