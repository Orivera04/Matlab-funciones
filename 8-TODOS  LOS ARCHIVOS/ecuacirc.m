%Programa que encuentra la ecuaci�n de una circunferencia dado el centro
% y el radio de la misma.
x0= input('Deme la coordenada x0 del centro: x0= ');
y0= input('Deme la coordenada y0 del centro: y0= ');
radio=input('Deme el radio: r = ');
syms x y 
ecuacion = (x-x0)^2 + (y-y0)^2-radio^2;
%disp('La ecuaci�n de la cicunferencia es: ');
ecua= char(ecuacion);
fprintf('La ecuaci�n de la cicunferencia es:%s  ',ecua),
disp('= 0');
titulo=strcat(char(ecuacion),'= 0');
DrawCircle(x0,y0,radio);
axis equal;
title(titulo)


