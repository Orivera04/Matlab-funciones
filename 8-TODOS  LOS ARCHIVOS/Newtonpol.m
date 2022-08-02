

function [yi, a] = Newtonpol(x, y, xi)

% Values yi of the interpolating polynomial at the points xi.
% Coordinates of the points of interpolation are stored in 
% vectors x and y. Horner's method is used to evaluate 
% a polynomial. Second output parameter a holds coefficients
% of the interpolating polynomial in Newton's form.

a = divdiff(x, y);
n = length(a);
val = a(n);                  
for m = n-1:-1:1
   val = (xi - x(m)).*val + a(m);
end
yi = val(:);


function a = divdiff(x, y)

% Divided differences based on points stored in vectors x and y.
% This is a subfunction.

n = length(x);
for k=1:n-1
   y(k+1:n) = (y(k+1:n) - y(k))./(x(k + 1:n) - x(k));
end
a = y(:);
