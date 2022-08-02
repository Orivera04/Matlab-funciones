%Rotaciones de cuádricas
%Ecuación General: Ax^2+Bxy+Cx^2+Dx+Ey+F=0
clear;
clc;
syms x y t x1 y1 x2 y2
%Introducción de coeficientes.
Coef=input('Dar los coeficientes [A,B,C,D,E,F]= ');
A=Coef(1);B=Coef(2);C=Coef(3);D=Coef(4);E=Coef(5);F=Coef(6);

%Eliminación de términos en x,y. x1=x+h, y=y1+k.
%Ecuación agrupada:Ax1^2+Bx1y1+Cy1^2+px1+qy1+r=0.
%Haciendo p=0 y q=0 se obtiene:Ax1^2+Bx1y1+Cy1^2+r=0
%P=2*A*h+B*k+D;
%q=2*C*k+B*h+E;
%x1=x2*cos(t)-y2*sin(t);
%y2=x2*sin(t)+y2*cos(t);
h=(B*E-2*C*D)/(-B^2+4*C*A)
k=(D*B-2*A*E)/(-B^2+4*C*A)
r=A*h^2+B*h*k+C*k^2+D*h+E*k+F;
ecuatras=A*x1^2+B*x1*y1+C*y1^2+r
%T1=cos(t)^2;T2=sin(t)^2;T3=cos(t)*sin(t);
%ecuarot2=(A*T1+C*T2+B*T3)*x2^2+(A*T2+C*T1-B*T3)*y2^2+r;
G=A-C;
H=G^2+B^2
co=B;
ca=(2*G^2+B^2-2*G*H^(1/2))^(1/2);
cuadco=B^2;
cuadca=2*G^2+B^2-2*G*H^(1/2);
cuadhip=2*H-2*G*H^(1/2);
T1=cuadca/cuadhip;
T2=cuadco/cuadhip;
T3=(ca*co)/cuadhip;
%Ecuacion de la cónica trasladada y rotada.
ecuarot=(A*T1+C*T2+B*T3)*x2^2+(A*T2+C*T1-B*T3)*y2^2+r







