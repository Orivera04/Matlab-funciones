function llenar_reg = fillreg(a,b,f1,f2) 
%Función para dibujar una región llena.f1,f2 son funciones
%[a,b] es el dominio  de ambas funbciones.Se colorea
%la región acotada por x=a, x=b, y=f1(x), y=f2(x).

%Definir los elementos del intervalo [a b]
x=linspace(a,b,50);
xi=fliplr(x);
fun1=inline(f1);
fun2=inline(f2);
y=fun1(x);
yi=fun2(xi);
X=[x,xi];
Y=[y,yi];
fill(X,Y,'b')
