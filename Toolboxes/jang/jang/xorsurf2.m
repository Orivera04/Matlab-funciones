% Surface plot of 2-1-1 MLP with jumping connection

k = 1000;
w1 = [1 1];
b1 = [-1.5];
w2 = [1 1 -2];
b2 = -0.5;

point_n = 21;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x, y);
input = [xx(:) yy(:)]';
net3 = [w1 b1]*[input; ones(1, size(input, 2))];
out3 = 1./(1+exp(-k*net3));

zz1 = reshape(out3(1, :), point_n, point_n);
zz2 = (xx + yy - 0.5)/2;
index = find(zz2 < 0);
zz2(index) = nan*index;

subplot(2,2,1);
plot(x, 1.5-x);
line(0, 0, 'linestyle', 'o', 'color', 'g');
line(0, 1, 'linestyle', 'x', 'color', 'm');
line(1, 0, 'linestyle', 'x', 'color', 'm');
line(1, 1, 'linestyle', 'o', 'color', 'g');
axis([0 1 0 1]); axis square;
xlabel('x1'); ylabel('x2'); title('(a) x3');

subplot(2,2,2);
mesh(xx, yy, zz2);
line(0, 0, 0, 'linestyle', 'o', 'color', 'g');
line(0, 1, 0, 'linestyle', 'x', 'color', 'm');
line(1, 0, 0, 'linestyle', 'x', 'color', 'm');
line(1, 1, 1, 'linestyle', 'o', 'color', 'g');
axis([0 1 0 1 0 1]);
axis square
xlabel('x1'); ylabel('x2'); zlabel('x3'); title('(b) x4');
view([-20 30]);

set(findobj(gcf, 'type', 'axes'), 'box', 'on');
set(findobj(gcf, 'type', 'line'), 'linewidth', 3, 'markersize', 10);
