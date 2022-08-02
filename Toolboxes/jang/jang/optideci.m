%======= optimal decision boundary for a nonminimum phase channel

% Roger Jang, Aug-11-1995

order1 = 2;			% order of the equalizer
order2 = 2;			% order of the channel
delay = 0;			% delay of the equalizer
case_n = 2^(order1+order2-1);	% number of possible input combination

% The first column of s is s(t), the second is s(t-1), etc
s = zeros(case_n, order1+order2-1);
for i=1:case_n,
	s(i, :) = dec2othe(i-1, 2, size(s, 2));
end
s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = 0.5*s(:,1)+s(:,2);
x2 = 0.5*s(:,2)+s(:,3);

index1 = find(s(:,1+delay) > 0);
index2 = find(s(:,1+delay) < 0);

x_min = -3; x_max = 3;
y_min = -3; y_max = 3;

blackbg;
% Display the decision region for the optimal channel equalizer.
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
xlabel('x(t)'); ylabel('x(t-1)');
hold on

p1 = [x1(index1) x2(index1)];
p2 = [x1(index2) x2(index2)];

point_n = 51;
x_range = linspace(x_min, x_max, point_n);
y_range = linspace(y_min, y_max, point_n);
[xx, yy] = meshgrid(x_range, y_range);

covariance = 0.2*[1 0; 0 1];
inv_cov = inv(covariance);

z = f_de([xx(:) yy(:)], p1, p2, inv_cov);
zz = reshape(z, point_n, point_n);
uu = (zz>=0)-(zz<0);

fprintf('Plotting surfaces...\n');
index = find(z >= 0);
plot(xx(index), yy(index), 'c.');
title('Optimal Decision Region');
hold off
axis([x_min x_max y_min y_max]);
axis('square');

figure;
blackbg;
pcolor(xx, yy, uu);
axis square;
colormap(cool);
shading interp;

%save boundary xx yy zz

hold on;
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
xlabel('x(t)'); ylabel('x(t-1)');

% plotting boundary as a contour
[a lineH] = contour(xx, yy, zz, [-realmax 0 realmax], 'y');
set(lineH, 'linewidth', 5, 'linestyle', '-'); 
hold off

figure;
blackbg;
subplot(2,2,1);
new_zz = zz;
index1 = find(zz > 1);
new_zz(index1) = ones(size(index1));
index2 = find(zz < -1);
new_zz(index2) = zeros(size(index2));
surf(xx, yy, new_zz);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
title_str = 'Optimal Decision Surface';
xlabel('x(t)'); ylabel('x(t-1)'); title('Optimal Decision Surface');

subplot(2,2,2);
surf(xx, yy, new_zz);
hold on;
h = mesh(xx, yy, zeros(size(xx)));
% make the cutting surface transparent
hidden off
[a, contourH] = contour3(xx, yy, zz, [-realmax 0 realmax], 'y');
set(contourH, 'linewidth', 3);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
%frot3d on
xlabel('x(t)'); ylabel('x(t-1)'); title('Threshold = 0');

subplot(2,2,3);
surf(xx, yy, uu);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
%frot3d on
xlabel('x(t)'); ylabel('x(t-1)'); title('Decision Surface after Thresholding');

subplot(2,2,4);
pcolor(xx, yy, uu);
%save optideci xx yy uu
axis square; colormap(cool);
shading interp
xlabel('x(t)'); ylabel('x(t-1)'); title('Optimal Decision Boundary');

hold on
% plotting boundary as a contour
[a lineH] = contour(xx, yy, zz, [-realmax 0 realmax], 'y');
set(lineH, 'linewidth', 3, 'linestyle', '-'); 
hold off
