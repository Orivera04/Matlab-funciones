% Estas instrucciones comparan la interpolación
% lineal con la de spline cúbica.
x = 0:5;
y = [0,20,60,68,77,110];
new_x = 0:0.1:5
new_y1 = INTERP1(x,y,new_x, 'linear');
new_y2 = INTERP1(x,y,new_x, 'spline');
%subplot(2,1,1);
plot(new_x,new_y1,new_x,new_y2,x,y,'b.') , ...
title('Interpolación lineal y  spline cúbica'), ...
xlabel('xr'),grid, ...
axis( [-1,6,20,120])