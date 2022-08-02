%Rotaciones de c�nicas
%Ecuaci�n General: Ax^2+Bxy+Cx^2+Dx+Ey+F=0
clear;
clc;
syms x y  x1 y1 
%Introducci�n de coeficientes.
Coef=input('Dar los coeficientes [A,B,C,D,E,F]= ');
A=Coef(1);B=Coef(2);C=Coef(3);D=Coef(4);E=Coef(5);F=Coef(6);
B^2-4*A*C;
T2t=sym(B/(A-C));
if B/(A-C)<0
    C2t=-1/(sqrt(1+T2t^2)); 
else
   C2t=1/(sqrt(1+T2t^2));  
end
t=(C2t+1)/2;
u=1-t;
v=t^(1/2)*u^(1/2);
w=sqrt(t);
z=sqrt(u);
x=x1*w-y1*z;
y=x1*z+y1*w;
ecua=A*x^2+B*x*y+C*y^2+D*x+E*y+F;
simplify(ecua)

