%Programa para colorear una región limitada 
%por dos rectas y dos curvas: x=a,x=b, y=f(x), y)g(x).

%Definición de las funciones y=f(x), y=g(x)
disp('Definir las funciones f y g ');
syms x
f=input('f(x) = ');
g=input('g(x) = ');

%Definición de los límites de la región
%Las dos rectas: x=a, x=b
a=input('Dar el valor de a: ');
b=input('Dar el valor de b: ');
x=linspace(a,b,50);
y1=eval(f);
y2=eval(g);
m=min(y1);
M=max(y2);
hold on;
plot([a;a],[m-0.5;M+0.5]);
plot([b;b],[m-0.5;M+0.5]);
ezplot(f);
ezplot(g);
axis([a-0.1 b+0.1 m-1 M+1]);
fill([x, fliplr(x)], [y1, fliplr(y2)], 'c')