% Illustration of gradient descent for quadratic landscape.
% J.-S. Roger Jang, April 1996

a=1;b=1;c=1;d=-1;e=1;
%a=1;b=0;c=2;d=0;e=0;
xx=-3:.2:3;
yy=-2:.2:2;
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
contour(x, y, z, 10);
axis image;
hold on;
quiver(x, y, -dz_dx, -dz_dy); 
xlabel('X'); ylabel('Y'); title('(b)');

x0 = 1.5; y0 = 2;
gd_count = 201;
position = zeros(gd_count, 2);
position(1,1) = x0; position(1,2) = y0;
kappa = 0.02;
for i = 2:gd_count,
	dx = 2*a*position(i-1,1)+b*position(i-1,2)+d;
	dy = b*position(i-1,1)+2*c*position(i-1,2)+e;
	grad = [dx dy];
	position(i,:)=position(i-1,:)-kappa*grad/norm(grad);
end
plot(x0, y0, '*');
plot(position(gd_count,1), position(gd_count, 2), 'o');
new_pos = position(1:10:gd_count, :);
arrow(new_pos(:, 1), new_pos(:, 2), 0.6);
x_opt = position(gd_count,1); y_opt = position(gd_count,2);

x0 = -3; y0 = 1;
gd_count = 301;
position = zeros(gd_count, 2);
position(1,1) = x0; position(1,2) = y0;
kappa = 0.02;
for i = 2:gd_count,
	dx = 2*a*position(i-1,1)+b*position(i-1,2)+d;
	dy = b*position(i-1,1)+2*c*position(i-1,2)+e;
	grad = [dx dy];
	position(i,:)=position(i-1,:)-kappa*grad/norm(grad);
end
plot(x0, y0, '*');
plot(position(gd_count,1), position(gd_count, 2), 'o');
new_pos = position(1:10:gd_count, :);
arrow(new_pos(:, 1), new_pos(:, 2), 0.6);
hold off;

figure;
gd_count = 10;
position = zeros(gd_count, 2);

subplot(221);
contour(x, y, z, 10);
hold on;
x0 = -3; y0 = 1;
position(1,1) = x0; position(1,2) = y0;
kappa = 0.25;
for i = 2:gd_count,
	dx = 2*a*position(i-1,1)+b*position(i-1,2)+d;
	dy = b*position(i-1,1)+2*c*position(i-1,2)+e;
	grad = [dx dy];
	position(i,:)=position(i-1,:)-0.25*grad/norm(grad);
end
plot(x0, y0, '*');
arrow(position(:,1), position(:,2), 0.6);
plot(x_opt, y_opt, 'o');
title('kappa = 0.25');
hold off;
axis image;

subplot(222);
contour(x, y, z, 10);
hold on;
x0 = -3; y0 = 1;
position(1,1) = x0; position(1,2) = y0;
kappa = 1;
for i = 2:gd_count,
	dx = 2*a*position(i-1,1)+b*position(i-1,2)+d;
	dy = b*position(i-1,1)+2*c*position(i-1,2)+e;
	grad = [dx dy];
	position(i,:)=position(i-1,:)-grad/norm(grad);
end
plot(x0, y0, '*');
arrow(position(:,1), position(:,2));
plot(x_opt, y_opt, 'o');
title('kappa = 1');
hold off;
axis image;
