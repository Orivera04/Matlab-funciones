x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + cos(Y).^2 + Z.^2);
[xs,ys]=meshgrid(x,y);
zs=sin(-xs+ys/2);
slice(X,Y,Z,V,xs,ys,zs)
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Figure 26.32: Slice Plot Using a Surface')