%Programa para determinar las as�ntotas de la gr�fica de una funci�n.
syms x
%Definir la funci�n
num=x^2+2,
den=x-2,
polinum=sym2poly(num);
poliden=sym2poly(den);
gradnum=numel(polinum);
gradden=numel(poliden);
f=num/den;
%Dibujar la funci�n f 
ezplot(f,[-6 10])
hold on
%Calcular el l�mite cuando x->2, es decir cuando el denominador se hace 0
ld=limit((x^2+2)/(x-2),x,2,'right')
li=limit((x^2+2)/(x-2),x,2,'left')
%Comprobar si los l�mites anteriores son infinitos
if (ld==Inf & li==-Inf) | (ld==-Inf & li==Inf)
    disp('x=2 es una as�ntota vertical')
    plot([2 2],[-8 15])
    hold on
else
    disp('f no tiene as�ntotas verticales')

end
%Calcular as�ntotas horizontales
h=limit(f,x,Inf)
if h==Inf
    disp('f no tiene as�ntotas horizonales')
else
    disp('y=h es una as�ntota horizontal')
    plot([-6 10],[h h])
    hold on
end
if gradnum-gradden==1
%Calcular m y n para la as�ntota oblicua
m=limit(f/x,x,Inf);
n=limit(f-m*x,x,Inf);
%Determinar la ecuaci�n de la as�ntota oblicua
g=eval(m*x+2)
ezplot(g,[-6 10])
else
    disp('f no tiene as�ntotas oblicuas')
end


