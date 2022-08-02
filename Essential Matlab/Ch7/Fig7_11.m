[x y] = meshgrid(-2:.2:2, -2:.2:2);
V = x.^2 + y; 
dx = 2*x;
dy = 1;
[dx dy] = gradient(V, 0.2, 0.2);
axis equal
contour(x, y, V,'k'), hold on
quiver(x, y, dx, dy,'k'), hold off