% 
% Naive Steepest Descent 
% 
% E. Mizutani, 
%
% Rosenbrock's banana function. 
% minimum [1.1]  f(x,y)=0.
%

point_n = 25;
x=linspace(-2, 2, point_n);
y=linspace(-1, 3, point_n);
[xx,yy]=meshgrid(x,y);
zz= 100.*(yy-xx.^2).^2+(1-xx).^2;


subplot(221);
mesh(xx, yy, zz);
view([-20, 25]); set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('E(X,Y)');
title('(a) Banana function');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
subplot(222);
% The initial point
x0 = -1.9; y0 = 2;

%%% How many steps?
p_count = 60;

position = zeros(p_count, 2);
position(1,1) = x0; position(1,2) = y0;

% fx = -400.*(yy-xx.^2).*xx-2+2.*xx;
% fy = 200.*yy-200.*xx.^2; 

% fxx=1200.*xx.^2-400.*yy+2;
% fxy=-400.*xx;
% fyy=200;

X = x0; 
Y = y0; 
fx = -400.*(Y-X.^2).*X-2+2.*X;
fy = 200.*Y-200.*X.^2; 
g = [fx; fy];
% To make the first step zero!
step = 0.00000001 * g';


eta = 0.001; 
momentum = 0.8;

for i = 2:p_count,
	X = position(i-1,1);
	Y = position(i-1,2);
	fx = -400.*(Y-X.^2).*X-2+2.*X;
	fy = 200.*Y-200.*X.^2; 
	g = [fx; fy];
%%%	position(i,:)=position(i-1,:)-eta*g';
	position(i,:)=position(i-1,:)-eta*g' + momentum * step;
	step = -eta*g';
  if i > 50,
    eta = 0.01; 
  end
end


% Resampling to have a better contours
point_n = 100;
x=linspace(-2, 2, point_n);
y=linspace(-1, 3, point_n);

[xx,yy]=meshgrid(x,y);
zz= 100.*(yy-xx.^2).^2+(1-xx).^2;

contour(xx, yy, zz, 40);
hold on;
plot(x0, y0, '*');
arrow(position(:, 1), position(:, 2));
x_last = position(p_count,1); y_last = position(p_count,2);

plot(x_last, y_last, 'x');

xlabel('X'); ylabel('Y'); title('(b)');
hold off;
axis image;

%%%%%%%%%%%%%%%% 
subplot(223);

% Resampling to have a better contours
point_n = 100;
x=linspace(x_last-0.2, x_last+0.2, point_n);
y=linspace(y_last-0.2, y_last+0.2, point_n);
% x=linspace(-1.5, -0.5, point_n);
% y=linspace(0.5, 1.5, point_n);
[xx,yy]=meshgrid(x,y);
zz= 100.*(yy-xx.^2).^2+(1-xx).^2;

contour(xx, yy, zz, 40);
hold on;
plot(x0, y0, '*');
arrow(position(:, 1), position(:, 2));
x_last = position(p_count,1); y_last = position(p_count,2);

plot(x_last, y_last, 'x');

xlabel('X'); ylabel('Y'); title('(c)');
hold off;
axis image;
%
% %%% Tail of the file
