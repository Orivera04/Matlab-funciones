%Ecuación de la recta en la forma punto-pendiente.
%Se da un punto de la recta (x0,y0) y la pendiente
% y se obtiene la ecaución de la recta: y=y0+m*x-m*x0.
x0=input('Introduzca la abscisa del punto dado x0: ');
y0=input('Introduzca la ordenada del punto dado y0: ');
m=input('Introduzca la pendiente de la recta m: ');
syms x y;
X0=-x0;
disp('La ecuación de la recta es: ');
fprintf('y = %3.2f %+3.2f(x %+3.2f)\n', y0,m,X0)
f=inline('y0+m*(x-x0)');
x1=input('Dé la abscisa de otro punto de la recta: ');
y1=f(m,x1,x0,y0);
disp('Las coordenadas del nuevo punto son:');
x1,y1
plot([x0,x1],[y0,y1])
title('Gráfica de la recta y=y0+m(x-x0)')

