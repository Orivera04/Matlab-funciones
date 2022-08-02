% Dibuja una esfera de radio r dadas sus eca. parametricas.
% Ecs. param.: x = sin ? cos ?, y = sin ? sin ?, z = cos ?.
% INICIO
input('Dame el radio, r = ');
phi=linspace(0,pi,30);           % rango de phi
theta=linspace(0,2*pi,30);       % rango de theta
[phi,theta]=meshgrid(phi,theta); % malla phi-theta
x=r*sin(phi).*cos(theta);        % Ecs. param. dela esfera.
y=r*sin(phi).*sin(theta);
z=r*cos(phi);
mesh(x,y,z);                     % Dibuja la esfera
axis equal                       % Ajuste ejes,pto. obs.,
view(135,30)
box on
xlabel('x-axis')                 % Etiqueta de ejes
ylabel('y-axis')
zlabel('z-axis')
% FIN