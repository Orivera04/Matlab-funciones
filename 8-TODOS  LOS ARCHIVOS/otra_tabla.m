%Otra forma de imprimir tablas
clc
disp('Tabla de exponenciales')
disp('**********************')
disp('       x      exp(x)  ')
x=0:0.1:2;
y=exp(x);
t=[x;y]';
disp(t);
disp('**********************')