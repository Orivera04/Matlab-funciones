%Facultad de Electrotecnia y Computaci�n
%Agosto 2012
clear;
clc;
%Definir tiempo de recorrido.Ej t=0:0.1.6.3
%Ecuaciones param�tricas. Ej. x=cos(2*t), y=sin(2*t)
t=input('tiempo de recorido: ');
n=numel(t);
%Definir ecuaciones param�tricas del movimiento circular
r=input('radio= ');
x=r*cos(t);
y=r*sin(t);
%axis equal
seg=0.2;
plot(x,y)
%h=input('holgura de ejes: ');
axis([-r-3 r+3 -r-3 r+3]);
axis equal;
hold on;
dx=-r*sin(t);
dy=r*cos(t);
%definir movimiento
 for i=1:n
    p0=[x(i),y(i)];
    p1=p0+[dx(i)/2,dy(i)/2];
    [xx,yy]=arrow2(p0,p1,4*r); 
    %h=plot(x(i),y(i),'ro');
    %h=plot([p0(1),p1(1)],[p0(2),p1(2)])
    h=plot(xx,yy,'r')
    pause(seg)
    delete(h)
end
hold off
clear