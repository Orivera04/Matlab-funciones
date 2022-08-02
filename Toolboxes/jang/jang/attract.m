point_n = 21;
[xx, yy, zz] = peaks(point_n);
dx = 6/(point_n - 1);
dy = 6/(point_n - 1);
[px, py] = gradient(zz, dx, dy);
quiver(xx, yy, px, py);
axis equal; axis square;
axis([-inf inf -inf inf]);
