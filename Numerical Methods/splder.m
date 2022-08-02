
function p = splder(k, pp, x)

% Piecewise polynomial representation of the derivative
% of order k (O <= k <= 3) of a cubic spline function in the 
% pp form with the breakpoints stored in the vector x.

m = pp(3);
lx4 = length(x) + 4;
n = pp(lx4);
c = pp(1 + lx4:length(pp))';
c = reshape(c, m, n);
b = pold(c, k);
b = b(:)';
p = pp(1:lx4);
p(lx4) = n - k;
p = [p b];