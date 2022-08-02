% trapez_n(f_name, a, b, n) integrates a function, f_name
% by the trapezoidal rule.  
% a and b are lower and upper limits.  n is the number of
% intervals.
% Copyright S. Nakamura, 1995
function I = trapez_n(f_name, a, b, n)
   h = (b-a)/n;
   x = a+(0:n)*h;  f = feval(f_name, x);
   I =  trapez_v(f,h)

