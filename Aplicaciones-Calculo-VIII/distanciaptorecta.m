%Distancia de un punto a una recta

%Dar coeficientes de la ecuación de la recta
A=input('Dar el coeficiente A: ');
B=input('Dar el coeficiente B: ');
C=input('Dar el coeficiente C: ');

%Dar el punto M
xo=input('Dar xo: ');
yo=input('Dar yo: ');
%Normalizar la recta
normalizacion(A,B,C);
syms x y
dist=subs(ecnormal,{x,y},{xo,yo});
distancia=abs(dist)

