%Movimiento circular uniforme
%Hecho por R. Biones
%Facultad de Electrotecnia y Computaci�n
%Agosto 2012
clear;
clc;
%Definir tiempo de recorrido.Ej t=0:0.1.6.3
%Ecuaciones param�tricas. Ej. x=cos(2*t), y=sin(2*t)
t=input('tiempo de recorido: ');
n=numel(t);
%Definir ecuaciones param�tricas del movimiento
x=input('ecuaci�n para x: x(t)= ');
y=input('ecuaci�n para y: y(t)= ');
r=sqrt(x(1)^2+y(1)^2);
%axis equal
axis([-r-1 r+1 -r-1 r+1])
seg=0.2;
plot(x,y)
axis equal
%definir movimiento
 for i=1:n
    hold on
    h=plot(x(i),y(i),'ro');
    pause(seg)
    delete(h)
end
hold off
clear
