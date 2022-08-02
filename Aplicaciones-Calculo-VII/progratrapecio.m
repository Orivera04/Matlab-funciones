%Programa de la regla del trapecio 
a=input('deme el limite inferior de integracion: ');
b=input('deme el limite superior de integracion: ');
n=input('deme el No.de subintervalos de la particion: ');
h=(b-a)/n;
x=a:h:b;
f=input('deme la funcion a integrar: ');
g=eval(f);
g
suma = h*sum(g);
integral=suma - h*(g(1)+g(n+1))/2
