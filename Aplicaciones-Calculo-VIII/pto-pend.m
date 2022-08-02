%Ecuación de la recta en la forma punto-pendiente.
%Se da un punto de la recta (x0,y0) y la pendiente
% y se obtiene la ecaución de la recta: y=y0+m*x-m*x0.
x0=input('Introduzca la abscisa del punto dado x0: ');
y0=input('Introduzca la ordenada del punto dado y0: ');
m=input('Introduzca la pendiente de la recta m: ');
syms x y;
disp('La ecuación de la recta es: ');
fprintf('y = %f3.2  %f3.2(x-f3.2)\n', y0,m,x0)
