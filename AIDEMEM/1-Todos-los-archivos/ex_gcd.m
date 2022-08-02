a = 50:100;
[x, y]=meshgrid(a);
z = lcm(x,y);
contour(z(30:50,30:50)); axis equal tight off
