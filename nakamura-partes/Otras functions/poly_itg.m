% poly_itg(p) integrates a polynomial p which is 
% in a power series. The result is also a power series.
% Copyright S. Nakamura, 1995
function py = poly_itg(p)
n=length(p);
py = [p.*[n:-1:1].^(-1),0];

