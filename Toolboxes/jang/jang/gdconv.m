% Illustration of gradient descent.
% J.-S. Roger Jang, June 1993

a=1;b=1;c=1;d=-1;e=1;
xx=-3:.2:3;
yy=-3:.2:3;
[x,y]=meshgrid(xx,yy);
cx1 = 1.5; cy1 = -1; % center for the first bowl
z1 = (1+2*(x-cx1).^2+(y-cy1).^2).^(-1);
cx2 = -1; cy2 = 1.5; % center for the second bowl
z2 = (1+(x-cx2).^2+(y-cy2).^2).^(-1);
z = -(z1+0.6*z2);

subplot(221);
mesh(x, y, z);
axis([-inf inf -inf inf -inf inf]);
view([-15, 30]); set(gca, 'box', 'on');
xlabel('x'); ylabel('y'); title('(a)');

subplot(222);
contour(x, y, z, 8);
axis image;
hold on;
%[px, py] = gradient(z,.2,.2);
%quiver(x, y, -px, -py); 
xlabel('x'); ylabel('y');

x0 = 2; y0 = 3;
leng = 301;
kappa = 0.02;
position = zeros(leng, 2);
position(1,1) = x0; position(1,2) = y0;
for i = 2:leng,
	x = position(i-1,1);
	y = position(i-1,2);
	dz1_dx = -4*(x-cx1)/(1+2*(x-cx1)^2+(y-cy1)^2)^2;
	dz1_dy = -2*(y-cy1)/(1+2*(x-cx1)^2+(y-cy1)^2)^2;
	dz2_dx = -2*(x-cx2)/(1+(x-cx2)^2+(y-cy2)^2)^2;
	dz2_dy = -2*(y-cy2)/(1+(x-cx2)^2+(y-cy2)^2)^2;
	grad = -[dz1_dx+0.6*dz2_dx dz1_dy+0.6*dz2_dy];
	position(i,:)=position(i-1,:)-kappa*grad/norm(grad);
end
plot(x0, y0, '*');
plot(position(leng, 1), position(leng, 2), 'o');
%plot(position(:,1), position(:,2), '--');
new_pos = position(1:10:leng, :);
arrow(new_pos(:,1), new_pos(:,2), 0.6);

x0 = 2.5; y0 = 3;
leng = 301;
kappa = 0.02;
position = zeros(leng, 2);
position(1,1) = x0; position(1,2) = y0;
for i = 2:leng,
	x = position(i-1,1);
	y = position(i-1,2);
	dz1_dx = -4*(x-cx1)/(1+2*(x-cx1)^2+(y-cy1)^2)^2;
	dz1_dy = -2*(y-cy1)/(1+2*(x-cx1)^2+(y-cy1)^2)^2;
	dz2_dx = -2*(x-cx2)/(1+(x-cx2)^2+(y-cy2)^2)^2;
	dz2_dy = -2*(y-cy2)/(1+(x-cx2)^2+(y-cy2)^2)^2;
	grad = -[dz1_dx+0.6*dz2_dx dz1_dy+0.6*dz2_dy];
	position(i,:)=position(i-1,:)-kappa*grad/norm(grad);
end
plot(x0, y0, '*');
plot(position(leng, 1), position(leng, 2), 'o');
%plot(position(:,1), position(:,2), '--');
new_pos = position(1:10:leng, :);
arrow(new_pos(:,1), new_pos(:,2), 0.6);
title('(b)');

hold off;
