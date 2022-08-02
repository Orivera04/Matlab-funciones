%Movimiento senoidal

clc;
%Definir el tiempo del recorrido
t=input('El tiempo del recorrido es: ');
n=numel(t);

%Definir la función cudrática del movimiento parabólico
f=input('La función f es f(t)= ');

%Definir el movimiento parabólico
a=input('El límite superior de la escala en eje x es: a= ');
b=input('El límite inferior de la escala en eje y es: b= ');
c=input('El límite superior de la escala en eje y es: c= ');

seg=input('El retardo en el tiempo es: seg = ');
axis([0 a b c])
grid on
for i=1:n
    hold on
    plot(t(i),f(i),'r*')
    pause(seg)
end
hold off
clear