%Transformaciones de gr�fics en R2
clear;
clc;
syms c
ECX=[c,0;0,1];
ECY=[1,0;0,c];
CORTEX=[1,c;0,1];
CORTEY=[1,0;c,1];
IDEN=[1,0;0,1];
REFX=[1,0;0,-1];
REFY=[-1,0;0,1];
REFY_X=[-1,0;0,-1];
REFYX=[0,1;1,0];
REFYX_X=[0,1;-1,0];
REFY_YMX=[0,-1;1,0];
REF_YMX=[0,-1;-1,0];
T=input('Introduzca matriz de transformaci�n. ');
if isreal(T)==0
    c=input('valor de c: ');
    T=eval(T)
end
x=input('Dar dominio de la gr�fica: x=');
y=input('Dar la funci�n f(x)= ');
a=min(x);b=max(x);p=min(y);q=max(y);
G=[x;y];%Matriz de la gr�fica.
%Dibujar y=f(x).
plot(x,y);
hold on;
plot([0 0],[p q],'k');
plot([a b],[0 0],'k');
%Dibujar gr�fica transformada.
GT=T*G;
e=min(GT(1,:));f=max(GT(1,:));h=min(GT(2,:));k=max(GT(2,:));
r=min(a,e);t=max(b,f);u=min(p,h);v=max(q,k);
plot([0 0],[u-1 v+1],'k');
plot([r-1 t+1],[0 0],'k');
plot(GT(1,:),GT(2,:),'r');

