%Tangentes a una circunferencia
%Dibujar la circunferencia
t=0:0.1:2*pi+0.1;
x=3*cos(t);
y=3*sin(t);
plot(x,y);

axis([-6 6 -6 6]);
axis equal;
%Vector radial y vector tangente localizado
syms t;
xx=3*cos(t);
yy=3*sin(t);
xt=-3*sin(t);
yt=3*cos(t);
%vector tangente=vector radial+vector tangente localizado.
tan=[xx,yy]+[xt,yt];

%Dibujar tangentes
hold on;
for t=0:pi/4:2*pi+0.1
ini=eval([xx,yy])
fin=eval([tan(1),tan(2)])
drawline([ini',fin'],'r-')
end
hold off

