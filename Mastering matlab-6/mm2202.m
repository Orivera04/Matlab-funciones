x = [-1.5:0.125:1.5];
y = [-.6:0.125:2.8];
[X,Y] = meshgrid(x,y) ;
Z = 100.*(Y-X.*X).^2 + (1-X).^2; 
mesh(X,Y,Z)
hidden off
xlabel('x(1)'), ylabel('x(2)')
title('Figure 22.2: Banana Function')
hold on
plot3(1,1,1,'k.','markersize',20)
hold off
%(mm2202.m plot)