function [x1,x2] = ecuacion(a,b,c)
%Resolucion de ecuaciones cuadraticas
d = b^2 - 4*a*c;
x1 = (-b + sqrt(d))/(2*a);
x2 = (-b - sqrt(d))/(2*a);
