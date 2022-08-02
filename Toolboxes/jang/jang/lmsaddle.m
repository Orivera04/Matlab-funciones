% LM directions around a saddle point of hyperbolic paraboloid
% J.-S. Roger Jang, April 1996
% Revised by E. Mizutani, June 1996

% Starting point (2, 1)
x0 = 2; y0 = 1;

a=1;b=0;c=-1;d=0;e=0;
A = [2*a b; b 2*c];		% Note that A = H (Hessian)
B = [d; e];
C = 0;
point_n = 25;
x=linspace(-15, 15, point_n);
y=linspace(-15, 15, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy;

clf;
subplot(131);
mesh(xx, yy, zz);
view([-25, 10]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
axis square;
xlabel('X'); ylabel('Y'); zlabel('E(x,y)');
title('(a)');
hold on
X = [x0 y0]';
E_tmp = 0.5*X'*A*X+B'*X+C;
line(x0, y0, E_tmp, 'linestyle', 'O'); 

subplot(132);
% Resampling to have a finer contours
point_n = 50;
x=linspace(-15, 15, point_n);
y=linspace(-15, 15, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy;
contour(xx, yy, zz, 12);
hold on;

% Resampling to have a coarse gradient field
point_n = 11;
x=linspace(-15, 15, point_n);
y=linspace(-15, 15, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy;
[dx, dy] = gradient(zz, 30/(point_n-1), 30/(point_n-1));
quiver(x, y, -dx, -dy);
plot(x0, y0, 'O');
xlabel('X'); ylabel('Y'); title('(b)');
axis image;

subplot(133);
gd_pos = zeros(2, 2);
newton_pos = zeros(2, 2);
lm_pos = zeros(2, 2);
x = [x0; y0];
g = A*x+B;
% Find descent directions
gd_dir = -g;
gd_dir = gd_dir/norm(gd_dir);

newton_dir = -inv(A)*g;
newton_dir = newton_dir/norm(newton_dir);

lambda = 0.2;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir1 = lm_dir/norm(lm_dir);
lambda = 1;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir2 = lm_dir/norm(lm_dir);
lambda = 4;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir3 = lm_dir/norm(lm_dir);
lambda = 6;
lm_dir = -inv(A+lambda*eye(size(A)))*g;
lm_dir4 = lm_dir/norm(lm_dir);

gd_pos = [x x+gd_dir];
newton_pos = [x x+newton_dir];
lm_pos1 = [x x+lm_dir1];
lm_pos2 = [x x+lm_dir2];
lm_pos3 = [x x+lm_dir3];
lm_pos4 = [x x+lm_dir4];

% Resampling to have finer contours
point_n = 40;
x=linspace(0.5, 2.5, point_n);
y=linspace(0, 2, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy;
contour(xx, yy, zz, 8);
hold on;
plot(x0, y0, 'O');
text(0.7, 1.4, 'SD','fontsize', 12);
text(0.6, 0.5, 'Newton', 'fontsize', 12);
text(1.7, 0.2, 'LM(1)','fontsize', 12);
text(1.7, 1.8, 'LM(4)','fontsize', 12);
arrow(gd_pos(1, :), gd_pos(2, :), 0.2);
arrow(newton_pos(1, :), newton_pos(2, :), 0.2, 'r-');
%  arrow(lm_pos1(1, :), lm_pos1(2, :), 0.2, 'g-');
arrow(lm_pos2(1, :), lm_pos2(2, :), 0.2, 'c-');
arrow(lm_pos3(1, :), lm_pos3(2, :), 0.2, 'm-');
%  arrow(lm_pos4(1, :), lm_pos4(2, :), 0.2, 'w-');
xlabel('X'); ylabel('Y'); title('(c)');
hold off;
axis([0.5 2.5 0. 2.]);
axis image;
