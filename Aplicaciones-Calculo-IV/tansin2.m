%Tangentes a una senoide.
%Dibujar la circunferencia
clear;
t=0:0.1:2*pi;
x=t;
y=3*sin(t);
plot(x,y);
grid on;
hold on;

axis([0 10 -4 4]);
axis equal;
%Vector radial y vector tangente localizado
syms t;
xx=t;
yy=3*sin(t);
xt=1/2;
yt=3*cos(t)/2;
%vector tangente=vector radial+vector tangente localizado.
tan=[xx,yy]+[xt,yt];

%Dibujar tangentes

for t=0:pi/4:2*pi
ini=eval([xx,yy])
fin=eval([tan(1),tan(2)])
h=drawline([ini',fin'],'r-');
end
hold off
