% Hemstitching search path
% J.-S. Roger Jang, April 1996

% f(x,y) = ax^2+bxy+cy^2+dx+ey+f
a=1;b=0;c=5;d=0;e=0;f=0;
A = [a b/2; b/2 c];
B = [d; e];
C = f;
point_n = 25;
x=linspace(-3, 3, point_n);
y=linspace(-2, 2, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy+f;

subplot(221);
mesh(xx, yy, zz);
view([-10, 35]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('(a)');

subplot(222);
x0 = 3; y0 = 1;
gd_count = 7;
position = zeros(gd_count, 2);
position(1,1) = x0; position(1,2) = y0;
t = position(1, :)';
contour_level = t'*A*t+B'*t+C;
kappa = 0.02;
for i = 2:gd_count,
	g = 2*A*t+B;
	eta = g'*g/(2*g'*A*g);
	position(i,:)=position(i-1,:)-eta*g';
	t = position(i,:)';
	contour_level = [contour_level; t'*A*t+B'*t+C];
end

% Resampling to have a better contours
point_n = 100;
x=linspace(-3, 3, point_n);
y=linspace(-2, 2, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy+f;

contour(xx, yy, zz, contour_level);
hold on;
plot(x0, y0, '*');
arrow(position(:, 1), position(:, 2));
x_opt = position(gd_count,1); y_opt = position(gd_count,2);
xlabel('X'); ylabel('Y'); title('(b)');
hold off;
axis image;
