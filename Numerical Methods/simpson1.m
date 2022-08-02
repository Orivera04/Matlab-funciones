%Regla de Simpson
a=input('Dar limite inferior a: ');
b=input('Dar limite superior b: ');
n=input('Dar No. par de subintervalos n: ');
h=(b-a)/n;
x=a:h:b;
f1=input('Dar fn. a integrar (cadena) f: ');
f=eval(f1);
suma1=h*(f(1)+f(n+1))/3;
suma2=0;
for i=2:2:n
    suma2=suma2+4*h*f(i)/3;
end
suma3=0;
for i=3:2:(n-1)
    suma3=suma3+2*h*f(i)/3;
end
integral=suma1+suma2+suma3
