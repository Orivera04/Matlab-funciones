% Simps_n(f_name, a, b, n) integrates the function named f_name
% in the argument by the extended Simpson's rule.  
% a and b are lower and upper limits.
% n is the number of intervals to be used.
% Copyright S. Nakamura, 1995
function I = Simps_n(f_name, a, b, n)
   h = (b-a)/n;
   x = a+(0:n)*h;  f = feval(f_name, x);
   I =  Simps_v(f,h)

