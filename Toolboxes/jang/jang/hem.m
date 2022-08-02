% 
% Hemstitching search path
%
% Quadratic case --- the method of steepest descent
%
% J.-S. Roger Jang, April 1996
% Revised by E. Mizutani, June 8, 1996
%
% E(x,y) = ax^2+bxy+cy^2+dx+ey+f
%
% E(x,y) = 1/2 * t'*A*t+B'*t+C;
%
a=1;b=1;c=1;d=-1;e=1;f=0;
% A = [a b/2; b/2 c];
A = [2*a b; b  2*c];
B = [d; e];
C = f;
point_n = 25;
x=linspace(-3, 3, point_n);
y=linspace(-2, 2, point_n);
[xx,yy]=meshgrid(x,y);
zz=a*xx.^2+b*xx.*yy+c*yy.^2+d*xx+e*yy+f;

subplot(221);
mesh(xx, yy, zz);
view([-20, 25]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('E(X,Y)');
title('(a)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(222);
% The initial point
x0 = -3; y0 = 1;
%% x0 = 2; y0 = 2;

%%% How many steps?
p_count = 7;

position = zeros(p_count, 2);
position(1,1) = x0; position(1,2) = y0;
t = position(1, :)';
contour_level = 1/2 * t'*A*t+B'*t+C;

g_old = A*t+B;

for i = 2:p_count,
	g = A*t+B;
	eta = g'*g/(g'*A*g);
	position(i,:)=position(i-1,:)-eta*g';
	t = position(i,:)';
	contour_level = [contour_level; 1/2 * t'*A*t+B'*t+C];
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
x_last = position(p_count,1); y_last = position(p_count,2);
%
% plot(x_last, y_last, 'x');
%
xlabel('X'); ylabel('Y'); title('(b)');
hold off;
axis image;
%
%%% Tail of the file
