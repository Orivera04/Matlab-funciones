% Estas instrucciones comparan la interpolaci�n
% lineal con la de spline c�bica.
x = 0:5;
y = [0,20,60,68,77,1101];
new-x = 0:0.1:1.5
new-y1 = interpl(x,y,new-x, 'linear');
new-y2 = interpl(x,y,new-x, 'spline');
subplot(2,1,1);
plot(new-x,new-yl,new-x,new-y2,x,y,'o.') , ...
title('Interpo1aci�n lineal y con spline c�bica'), ...
xlabel('xr'),grid, ...
axis( [-1,6,20,120])