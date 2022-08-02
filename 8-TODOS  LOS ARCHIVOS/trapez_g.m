% function trapez_g: same as trpez_n except this
% will plot the function.
% Copyright S. Nakamura, 1995 
function I = trapez_g(f_name, a, b, n)
n=n;hold off
   h = (b-a)/n;
   x = a+(0:n)*h;  f = feval(f_name, x);
   I = h/2*(f(1) + f(n+1));
   if n>1 I = I +  h*sum(f(2:n));end
h2 = (b-a)/100;
xc = a+(0:100)*h2;  fc = feval(f_name, xc);
plot(xc,fc,'r'); hold on
title('Trapezoidal Rule'); xlabel('x');ylabel('y');
plot(x,f);
plot(x,zeros(size(x)))
for i=1:n; plot([x(i),x(i)], [0,f(i)]); end

