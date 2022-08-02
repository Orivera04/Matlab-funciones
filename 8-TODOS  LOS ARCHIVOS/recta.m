function y=recta(x1,y1,m)
%Programa que encuentra la ecuación de una recta dado un punto y 
%la pendiente de la misma.

syms x y;
y=y1+m*(x-x1);
%Halle otro punto para graficar la recta
delta_x=input('Deme un incremento de x1: ') 
x2=x1+delta_x
y2=y1+m*delta_x
disp('La ecuación de la recta es: ')
lde='y = ';
lie=char(y1+m*(x-x1));
title(strcat(lde,lie));
line([x1,x2],[y1,y2])

