function Itrap = trapecio2(fun,a,b,n)
%Regla trapezoidal estendida ver #2. fun: funcion,
%[a,b]:intervalo de integracion, n: No. de ptos.
h=(b-a)/n;
x=a + (0:n)*h; 
f=feval(fun,x);
Itrap=trapecio1(f,h);