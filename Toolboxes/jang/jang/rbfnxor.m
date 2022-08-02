trn_data = [0 0 0; 0 1 1; 1 0 1; 1 1 0];

point_n = 21;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x, y);
input = [xx(:) yy(:)];
sigma = 1/(2*sqrt(2*log(2)));
w1x = exp(-((input(:,1)-0)/sigma).^2/2);
w2x = exp(-((input(:,1)-1)/sigma).^2/2);
w1y = exp(-((input(:,2)-0)/sigma).^2/2);
w2y = exp(-((input(:,2)-1)/sigma).^2/2);
w1 = w1x.*w2y;
w2 = w2x.*w1y;
zz = w1 + w2;

zz1 = reshape(w1, point_n, point_n);
zz2 = reshape(w2, point_n, point_n);
zz3 = reshape(zz, point_n, point_n);
v_angle = [20 60];

subplot(2,3,1); mesh(xx, yy, zz1);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y'); title('(a) output for node 1');
subplot(2,3,2); mesh(xx, yy, zz2);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y'); title('(b) output for node 2');
subplot(2,3,3); mesh(xx, yy, zz3);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y'); title('(c) output for node 3');

subplot(2,3,4); pcolor(xx, yy, zz1); axis square;
xlabel('x'); ylabel('y'); shading interp;
subplot(2,3,5); pcolor(xx, yy, zz2); axis square;
xlabel('x'); ylabel('y'); shading interp;
subplot(2,3,6); pcolor(xx, yy, zz3); axis square;
xlabel('x'); ylabel('y'); shading interp;

set(findobj(gcf, 'type', 'axes'), 'box', 'on');
colormap(gray);


