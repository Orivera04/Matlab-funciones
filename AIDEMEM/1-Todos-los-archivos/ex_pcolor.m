x = linspace(-1, 1, 50);
[xx, yy]=meshgrid(x);
z = (abs(xx)+abs(yy))*sin(3*pi*(xx.^2+yy.^2));
subplot(1,2,1)
pcolor(z);colormap(gray)
subplot(1,2,2)
pcolor(xx,yy,z);colormap(gray)