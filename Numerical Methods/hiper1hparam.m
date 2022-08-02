% Dibuja un hiperboloide de una hoja dadas sus ecs. param.
% x = a cosh u cos v
% y = b cosh u sin v
% z = c sinh u
a=input('Dame semieje de elipse en eje x: ');
b=input('Dame semieje de elipse en eje y: ');
c=input('Dame semieje imaginario de hiperbolas: ');
% Intervalos de u,v. Rejilla u-v.
u=linspace(-2,2,40);
v=linspace(0,2*pi,40);
[u,v]=meshgrid(u,v);
% Ecuaciones parametricas del hiperboloide
x = a*cosh(u)*cos(v);
y = b*cosh(u)*sin(v);
z = c*sinh(u);
% Dibujo del hiperboloide
mesh(x,y,z);
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
title('Hyperboloid of One Sheet')
view(160,30)