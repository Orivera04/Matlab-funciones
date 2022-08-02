R=0:.1:1;
THETA=0:pi/36:2*pi;
[r,theta]=meshgrid(R,THETA);
x=r.*cos(theta);
y=r.*sin(theta);
z=r.*cos(2*theta);
mesh(x,y,z);
grid on;
xlabel('Eje x');
ylabel('Eje y');
zlabel('Eje z');
title('La grafica de z = yˆ2 - xˆ2')