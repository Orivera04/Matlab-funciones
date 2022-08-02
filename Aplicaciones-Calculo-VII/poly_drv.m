% poly_drv(xd,yd,a) fits a polynomial to data (xd,yd)
% and computes all derivatives of the polynomial at x=a.
% Copyright S. Nakamura, 1995
function der = poly_drv(xd,yd,a)
m = length(xd)-1;
d = polyfit(xd-a, yd, m);
c = d(m:-1:1);
fact(1)=1; for i=2:m; fact(i)=i*fact(i-1);end
der = c.*fact;

