% Hessian around a saddle point
% J.-S. Roger Jang, April 1996

a=1;b=0;c=-1;d=0;e=0;
A = [a b/2; b/2 c];
B = [d; e];
C = 0;
point_n = 25;
xx=linspace(-3, 3, point_n);
%yy=linspace(-2, 2, point_n);
yy=linspace(0, 4, point_n);
[x,y]=meshgrid(xx,yy);
z=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;

subplot(221);
mesh(x, y, z);
view([-10, 35]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('f(x,y)');
title('(a)');

subplot(222);
%x0 = 2; y0 = 0.7;
x0 = 1; y0 = 2;
count = 2;
gd_pos = zeros(count, 2);
newton_pos = zeros(count, 2);
lm_pos = zeros(count, 2);
eta = 0.5;
x = [x0; y0];
g = A*x+B;
% Find all descent directions
gd_dir = -g;
gd_dir = gd_dir/norm(gd_dir);
newton_dir = -inv(A)*g;
newton_dir = newton_dir/norm(newton_dir);

lambda = 0.1;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir1 = lm_dir/norm(lm_dir);
lambda = 0.5;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir2 = lm_dir/norm(lm_dir);
lambda = 1;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir3 = lm_dir/norm(lm_dir);
lambda = 2;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir4 = lm_dir/norm(lm_dir);

gd_pos = [x x+gd_dir];
newton_pos = [x x+newton_dir];
lm_pos1 = [x x+lm_dir1];
lm_pos2 = [x x+lm_dir2];
lm_pos3 = [x x+lm_dir3];
lm_pos4 = [x x+lm_dir4];

contour_level = linspace(min(z(:)), max(z(:)), 10);

% Resampling to have a better contours
point_n = 100;
xx=linspace(-3, 3, point_n);
yy=linspace(0, 4, point_n);
[x,y]=meshgrid(xx,yy);
z=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;
contour(x, y, z, contour_level);
hold on;
plot(x0, y0, '*');
arrow(gd_pos(1, :), gd_pos(2, :), 0.2);
arrow(newton_pos(1, :), newton_pos(2, :), 0.2, 'r-');
arrow(lm_pos1(1, :), lm_pos1(2, :), 0.2, 'g-');
arrow(lm_pos2(1, :), lm_pos2(2, :), 0.2, 'c-');
arrow(lm_pos3(1, :), lm_pos3(2, :), 0.2, 'm-');
arrow(lm_pos4(1, :), lm_pos4(2, :), 0.2, 'w-');

xlabel('X'); ylabel('Y'); title('(b)');
hold off;
axis([min(xx) max(xx) min(yy) max(yy)]);
axis image;
