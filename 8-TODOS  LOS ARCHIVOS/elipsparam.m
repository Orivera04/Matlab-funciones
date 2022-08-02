% Dibuja un elipsoide dadas sus ecs. parametricas.
% x = a cos u sin v
% y = b sin u sin v
% z = c cos v
a=input('Dame el semieje a: ');
b=input('Dame el semieje b: ');
c=input('Dame el semieje c: ');
% intervalos de los parametros u, v y rejilla u-v.
u=linspace(0,2*pi,30);
v=linspace(0,pi,30);
[u,v]=meshgrid(u,v);
% Ecs. paramatricas del elipsoide:
x = a*cos(u).*sin(v);
y = b*sin(u).*sin(v);
z = c*cos(v);
% Dibujo del elipsoide
surf(x,y,z);