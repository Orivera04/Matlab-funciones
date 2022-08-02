function x = erfinv(y);
%ERFINV	Inverse of the error function.
%	x = erfinv(y) satisfies y = erf(x),
%	    -1 <= y < 1, -inf <= x <= inf.
%
%	See also ERF.

%	Cleve Moler, 12-31-90, 5-7-91, 7-25-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

x = NaN*ones(size(y));

% Coefficients in rational approximations.

a = [ 0.886226899 -1.645349621  0.914624893 -0.140543331];
b = [-2.118377725  1.442710462 -0.329097515  0.012229801];
c = [-1.970840454 -1.624906493  3.429567803  1.641345311];
d = [ 3.543889200  1.637067800];

% Central range.

y0 = .7;
k = find(abs(y) <= y0);
if any(k)
    z = y(k).*y(k);
    x(k) = y(k) .* (((a(4)*z+a(3)).*z+a(2)).*z+a(1)) ./ ...
         ((((b(4)*z+b(3)).*z+b(2)).*z+b(1)).*z+1);
end;

% Near end points of range.

k = find(( y0 < y ) & (y <  1));
if any(k)
	z = sqrt(-log((1-y(k))/2));
	x(k) = (((c(4)*z+c(3)).*z+c(2)).*z+c(1)) ./ ((d(2)*z+d(1)).*z+1);
end

k = find((-y0 > y ) & (y > -1));
if any(k)
	z = sqrt(-log((1+y(k))/2));
	x(k) = -(((c(4)*z+c(3)).*z+c(2)).*z+c(1)) ./ ((d(2)*z+d(1)).*z+1);
end

% Two steps of Newton-Raphson correction to full accuracy.
% Without these steps, erfinv(y) would be about 3 times
% faster to compute, but accurate to only about 6 digits.

x = x - (erf(x) - y) ./ (2/sqrt(pi) * exp(-x.^2));
x = x - (erf(x) - y) ./ (2/sqrt(pi) * exp(-x.^2));

% Exceptional cases.

k = find(y == -1);
if any(k), x(k) = -inf*k; end
k = find(y == 1);
if any(k), x(k) = inf*k; end
k = find(abs(y) > 1);
if any(k), x(k) = NaN*k; end
