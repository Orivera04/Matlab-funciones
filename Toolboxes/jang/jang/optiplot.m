% Display the decision region for the optimal channel equalizer.

order = 2;
lag = 0;
case_n = 2^(order+1);

% The first column of s is x(t), the second is x(t-1), etc
s = zeros(case_n, order+1);
for i=1:case_n,
	tmp = dec2othe(i-1, 2);
	if length(tmp)==0
		tmp = 0;
	end
	s(i,order+2-length(tmp):order+1) = tmp;
end
s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = channel(s(:,1), s(:, 2));
x2 = channel(s(:,2), s(:, 3));

% lag
index1 = find(s(:,1+lag) > 0);
index2 = find(s(:,1+lag) < 0);

x_min = -3; x_max = 3;
y_min = -3; y_max = 3;
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
hold on
xlabel('x(t)'); ylabel('x(t-1)');

p1 = [x1(index1) x2(index1)];
p2 = [x1(index2) x2(index2)];

point_n = 51;
x_range = linspace(x_min, x_max, point_n);
y_range = linspace(y_min, y_max, point_n);
[xx, yy] = meshgrid(x_range, y_range);

%covariance = 0.2*[2 0.2; 0 1];
%covariance = 0.2*[1 0.2; 0.5 0.4];
covariance = 0.2*[1 0; 0 1];
inv_cov = inv(covariance);

z = f_de([xx(:) yy(:)], p1, p2, inv_cov);

fprintf('Plotting surfaces...\n');
index = find(z >= 0);
plot(xx(index), yy(index), 'c.');
title('optimal decision region');
hold off
axis([x_min x_max y_min y_max]);
axis('square');

figure;
mesh(xx, yy, reshape(z, point_n, point_n));

figure;
zz = reshape(z > 0, point_n, point_n);
pcolor(xx, yy, zz);
axis square;
colormap(cool);
shading interp;

%save boundary xx yy zz

hold on;
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
xlabel('x(t)'); ylabel('x(t-1)');

% plotting boundary as a contour
[a lineH] = contour(xx, yy, zz, [-realmax 0.5 realmax]);
set(lineH, 'markersize', 15, 'color', 'k', 'linestyle', '.'); 
hold off
