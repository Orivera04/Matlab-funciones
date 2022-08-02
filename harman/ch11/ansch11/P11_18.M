% P11_18.M  Plot vector field lines
%
%  v=exp(-y^2) * j
%  v=exp(-x^2) * j
%
clear
clf
[x,y]=meshgrid(-1:0.1:1);
vyj1=exp(-y.^2);
zerox=zeros(length(vyj1));
figure(1)
quiver(x,y,zerox,vyj1);
title('Plot of vector field v=exp(-y.^2)*j ')
xlabel('x')
ylabel('y')
grid
pause
%
%
pause
vyj2=exp(-x.^2);
zeroy=zeros(length(vyj2));
figure(2)
quiver(x,y,zeroy,vyj2);
title('Plot of vector field v=exp(-x.^2)*j ')
xlabel('x')
ylabel('y')

