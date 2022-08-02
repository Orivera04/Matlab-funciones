% poly_add(p1,p2) adds two polynomials, p1 and p2,
% which are vectors of power coefficients.
% Copyright S. Nakamura, 1995
function p3 = poly_add(p1,p2)
n1=length(p1); n2 = length(p2);
if n1==n2 p3 = p1 + p2; end
if n1>n2  p3 = p1 + [zeros(1,n1-n2) ,p2];end
if n1<n2  p3 = [zeros(1,n2-n1) ,p1] + p2; end

