%Proyeccion de un punto sobre una recta
%Ecuación de la recta Ax+By+C=0 (y=(-Ax-C)/B)
A=input('coeficiente A:');
B=input('coeficiente B:');
C=input('coeficiente C:');
n=[A,B] %vector normal a la recta
P=input('Punto a proyectar:');
xr1=0;
yr1=(-A*xr1-C)/B;
h=input('incremento de xr1:');
xr2=P(1)+h;
yr2=(-A*xr2-C)/B;
plot([xr1,xr2],[yr1,yr2]);
hold on;
v=[xr1,yr1]-P;
vp=dot(v,n)/(A^2+B^2)*n
PP=P+2*vp;%Punto reflejado
plot(P(1),P(2),'or');
plot(PP(1),PP(2),'ok');
%legend('recta de proyección','punto proyectante','punto proyectado')
axis([xr1 xr2 yr1 yr2]);
axis equal