%Movimiento senoidal

clc;
%Definir el tiempo del recorrido
t=input('El tiempo del recorrido es: ');
n=numel(t);

%Definir la funci�n cudr�tica del movimiento parab�lico
f=input('La funci�n f es f(t)= ');

%Definir el movimiento parab�lico
a=input('El l�mite superior de la escala en eje x es: a= ');
b=input('El l�mite inferior de la escala en eje y es: b= ');
c=input('El l�mite superior de la escala en eje y es: c= ');

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