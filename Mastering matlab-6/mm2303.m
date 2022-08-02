x = linspace(0,pi,20);
y = linspace(-pi,pi,20);
[xx,yy] = meshgrid(x,y);
zz = myfun(xx,yy);
mesh(xx,yy,zz)
xlabel('x'), ylabel('y')
title('Figure 23.3: myfun.m plot')