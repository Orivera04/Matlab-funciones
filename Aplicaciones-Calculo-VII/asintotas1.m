%Programa para determinar las asíntotas verticales de la gráfica de una 
%función.
syms x
%Definir la función
num=x^2+2;
den=x-2;
f=num/den;
%Dibujar la función f 
ezplot(f,[-6 10])
hold on
%Calcular el límite cuando x->2, es decir cuando el denominador se hace 0
ld=limit((x^2+2)/(x-2),x,2,'right')
li=limit((x^2+2)/(x-2),x,2,'left')
%Comprobar si los límites anteriores son infinitos
if (ld==Inf & li==-Inf) | (ld==-Inf & li==Inf)
    disp('x=2 es una asíntota vertical')
    plot([2 2],[-20 30])
    hold on
else
    disp('f no tiene asíntotas verticales')

end
