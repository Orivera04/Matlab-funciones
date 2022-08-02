data_n = 100;
% === cluster 1
c1 = 0.6 + j*0.2;
data1 = c1 + (randn(data_n,1) + j*randn(data_n,1))/10;
% === cluster 2
c2 = 0.2 + j*0.6;
data2 = c2 + (randn(data_n,1) + j*randn(data_n,1))/10;
% === cluster 3
c3 = 0.8 + j*0.8;
data3 = c3 + (randn(data_n,1) + j*randn(data_n,1))/10;
% === final data
data = [data1; data2; data3];
tmp1 = (real(data)<0) | (real(data)>1);
tmp2 = (imag(data)<0) | (imag(data)>1);
index = tmp1 | tmp2;

data(find(index == 1), :) = [];

blackbg;
subplot(3,4,1);
h = plot(data, 'o');
set(h, 'markersize', 3);
axis equal; axis square;
axis([0 1 0 1]);
title('(a)');

point_n = 21;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x, y);
grid_point = xx(:) + j*yy(:);

grid_n = size(grid_point, 1);
data_n = size(data, 1);

tmp1 = grid_point*ones(1, data_n);
tmp2 = ones(grid_n, 1)*data.';
tmp = tmp1 - tmp2;
dist = sqrt(real(tmp).^2 + imag(tmp).^2);

subplot(3,4,2);
sigma = 0.02;
tmp = exp(-dist.*dist/(2*sigma^2));
zz = reshape(sum(tmp'), point_n, point_n);
mesh(xx, yy, zz);
view([-20 60]);
set(gca, 'box', 'on');
title('(b)');
axis([-inf inf -inf inf -inf inf]);

subplot(3,4,3);
sigma = 0.1;
tmp = exp(-dist.*dist/(2*sigma^2));
zz = reshape(sum(tmp'), point_n, point_n);
mesh(xx, yy, zz);
view([-20 60]);
set(gca, 'box', 'on');
title('(c)');
axis([-inf inf -inf inf -inf inf]);

subplot(3,4,4);
sigma = 0.2;
tmp = exp(-dist.*dist/(2*sigma^2));
zz = reshape(sum(tmp'), point_n, point_n);
mesh(xx, yy, zz);
view([-20 60]);
set(gca, 'box', 'on');
title('(d)');
axis([-inf inf -inf inf -inf inf]);
