%Dibuja un cono circular dadas sus ecuaciones parametricas
%Ecuaciones parametricas: x = r cos ?, y = r sin ?, z = r
%Inicio.
r=linspace(0,1,30);          % rango de r
theta=linspace(0,2*pi,30);   % rango de theta
[r,theta]=meshgrid(r,theta); % malla r-theta
x=r.*cos(theta);             % Ec. parametricas del cono
y=r.*sin(theta);             
z=r;                         
mesh(x,y,z)                  % Dibuja el cono
view(135,30)                 % Pto. de obs.,ajuste ejes,caja.
axis tight
box on
xlabel('x-axis')             % Etiqueta de ejes
ylabel('y-axis')
zlabel('z-axis')
% Fin.