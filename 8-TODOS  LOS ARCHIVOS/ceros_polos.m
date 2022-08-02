%Programa para calcular ceros y polos de una función racional.
%Dada una función raacional: f(x)=p(x)/q(x); los valores de x
%que hacen que p(x)=0 se llaman ceros de f(x) y los valores de
%x que hacen que q(x)=0 se llaman polos de f(x).
%Introducir el numerador de f(x)
clear
clc
syms x
p1=input('Escriba el numerador de f(x): ')
%Introducir el denominador de f(x)
q1=input('Escriba el denominador de f(x): ')
%Definición de la función f
f=simplify(p1/q1)
[p,q]=numden(f)
%Encontrar los ceros de f
ceros=solve(p);
%Seleccionar los polos reales:cr
cr=ceros(imag(ceros)==0)
m=numel(cr)
%Encontrar los polos de f
polos=solve(q);
%Seleccionar los polos reales: pr
pr=polos(imag(polos)==0)
n=numel(pr)
ezplot(f)
grid on
hold on
%Dibujar las asíntotas correspondientes a cada polo
for i=1:n
x1=pr(i);
x2=x1;
y1=input('Dar un valor para y1 en la asíntota: ')
y2=input('Dar un valor para y2 en la asíntota: ')
plot([x1,x2],[y1,y2])
end
%Dibujar los ceros de f
yceros=zeros(1,m)
plot(cr,yceros,'r*')








