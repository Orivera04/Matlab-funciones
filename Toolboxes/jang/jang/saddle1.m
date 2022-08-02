% Hessian around a saddle point
% J.-S. Roger Jang, April 1996

a=1;b=0;c=-1;d=0;e=0;
A = [a b/2; b/2 c];
B = [d; e];
C = 0;
point_n = 25;
xx=linspace(-3, 3, point_n);
yy=linspace(-2, 2, point_n);
[x,y]=meshgrid(xx,yy);
z=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;
dz_dx = 2*a*x+b*y+d;
dz_dy = b*x+2*c*y+e;

subplot(221);
mesh(x, y, z);
view([-10, 35]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('(a)');

subplot(222);
x0 = 3; y0 = 0.83;
gd_count = 6;
position = zeros(gd_count, 2);
position(1,1) = x0; position(1,2) = y0;
t = position(1, :)';
contour_level = t'*A*t+B'*t+C;
kappa = 0.02;
for i = 2:gd_count,
	g = A*t+B;
	eta = g'*g/(g'*A*g);
	position(i,:)=position(i-1,:)-eta*g';
	t = position(i,:)';
	contour_level = [contour_level; t'*A*t+B'*t+C];
end

% Resampling to have a better contours
point_n = 100;
xx=linspace(-3, 3, point_n);
yy=linspace(-2, 2, point_n);
[x,y]=meshgrid(xx,yy);
z=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;
%contour(x, y, z, contour_level);
contour(x, y, z, 10);
hold on;

% Resampling to have a coarse gradient field
point_n = 11;
xx=linspace(-3, 3, point_n);
yy=linspace(-2, 2, point_n);
[x,y]=meshgrid(xx,yy);
z=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;
[dx, dy] = gradient(z, 6/(point_n-1), 4/(point_n-1));
quiver(x, y, -dx, -dy);

%plot(x0, y0, '*');
%arrow(position(:, 1), position(:, 2));
xlabel('X'); ylabel('Y'); title('(b)');
hold off;
axis image;
