%Pertenencia de un punto P(xo,yo) a una curva f(x,y)=0.

%Introducir la ecuación de la curva (lado izquierdo)
clc
syms x y
g=input('f(x,y)= ');
f=horzcat(g,'=0');
disp('ecuación f(x,y)=0: '),disp(f);


%Dar las coordenadas del punto P
disp('Coordenadas de P:');
xo=input('coordenada xo: ');
yo=input('coordenada yo: ');

%sustitución de (xo,yo) en f
fdeP=subs(g,{x,y},{xo,yo});
if fdeP == 0
    disp('El punto P pertenece a f(x,y)=0')
else
    disp('El punto P no pertenece a f(x,y)=0')
end