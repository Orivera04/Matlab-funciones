x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + cos(Y).^2 + Z.^2);
slice(X,Y,Z,V,[0 3],[5 15],[-3 5])
h=contourslice(X,Y,Z,V,3,[5 15],[]);
set(h,'EdgeColor','k','Linewidth',1.5)
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Figure 26.33: Slice Plot with Selected Contours')