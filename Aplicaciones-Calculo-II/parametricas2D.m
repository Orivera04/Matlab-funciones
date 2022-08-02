%Ecuaciones paramétricas de la recta x=xo+a1*t,y=yo+a2*t
%Se da el punto(xo,yo) y el vector [a1,a2] paralelo a la recta

syms x y t
%Introducir el punto (xo,yo)
xo=input('Dar el valor de xo: ');
yo=input('Dar el valor de yo: ');

%Introducir el vector [a1,a2]
a1=input('Dar el valor de a1: ');
a2=input('Dar el valor de a2: ');

fprintf('1a ecuación x = %+4.2f %+4.2f*t\n',xo,a1);
fprintf('1a ecuación y = %+4.2f %+4.2f*t\n',yo,a2);

x=xo+a1*t;
y=yo+a2*t;

t=input('Dar un valor del parámetro t: ');

x1=xo+a1*t;
y1=yo+a2*t;

plot([xo,x1],[yo,y1])
