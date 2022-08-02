function Itrap = trapegraf(fun,a,b,n)
%Regla trapezoidal con grafica
n=n; hold off
h=(b-a)/n;
x=a+(0:n)*h;
f=feval(fun,x);
Itrap=h/2*(f(1) + f(n+1);
if n>1 Itrap=Itrap+h*sum(f(2:n));end
h2=(b-a)/100;
xc=a+(0:100)*h2; fc=feval(fun,xc);
plot(xc,fc,'r'); hold on
title('Regla Trapezoidal');xlabel('X');ylabel('Y');
plot(x,f);
plot(x,zeros(size(x))
for i=1:n; plot([x(i),x(i)],[0,f(i)]);end