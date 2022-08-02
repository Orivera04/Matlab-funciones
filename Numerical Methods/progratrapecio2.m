%Programa de la regla trapecial. Version No. 2
%a,b: limites de integracion. n: No. de subintervalos. h: paso.
a=input('Dar limite inferior a: ');
b=input('Dar limite superior b: ');
n=input('Dar No. de subintervalos n: '); 
h=(b-a)/n; % calculo del paso h
x=a:h:b; %definicion de particion de x
f1=input('Dar fn. a integrar (cadena) f: ');
f=eval(f1); %evaluacion de f en cada pto. x(i) de la particion.
%Calculo de la suma de las areas de los trapecios.
suma1=h*(f(1)+f(n+1))/2;
suma2=0;
for i=2:n
    suma2=suma2+f(i);
end
suma2=h*suma2;
integral= suma1+suma2
























