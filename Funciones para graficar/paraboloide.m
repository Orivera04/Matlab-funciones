R=0:.1:1;
THETA=0:pi/12:2*pi;
[r,theta]=meshgrid(R,THETA);
x=r.*cos(theta);
y=r.*sin(theta);
z=r.^2;
mesh(x,y,z);
grid on;
xlabel('Eje x');
ylabel('Eje y');
zlabel('Eje z');
title('La grafica de z = xˆ2 + yˆ2')
