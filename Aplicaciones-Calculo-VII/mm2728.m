x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + Y.^2 + Z.^2);
slice(X,Y,Z,V,[0 3],[5 15],[-3 5])
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Figure 27.28: Slice Plot Through a Volume')