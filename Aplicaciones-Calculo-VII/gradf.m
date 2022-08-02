function del = gradf(f)
% calcula el gradiente de una funcion de dos variables
syms x y;
fx = diff(f,x);
fy = diff(f,y);
del = [fx fy];
