load equtrain.dat
trn_data = equtrain;
positive_index = find(trn_data(:,3) > 0);
negative_index = 1:size(trn_data, 1);
negative_index(positive_index) = [];
positive = trn_data(positive_index,:);
negative = trn_data(negative_index,:);

figure
blackbg;
subplot(2,3,1);
if matlabv == 4,
	line(positive(:,1), positive(:,2), 'linestyle', 'o', ...
	'markersize', 3, 'color', 'y');
	line(negative(:,1), negative(:,2), 'linestyle', 'x', ...
	'markersize', 2, 'color', 'm');
elseif matlabv == 5,
	line(positive(:,1), positive(:,2), 'marker', 'o', ...
	'linestyle', 'none', 'markersize', 2, 'color', 'y');
	line(negative(:,1), negative(:,2), 'marker', 'x', ...
	'linestyle', 'none', 'markersize', 3, 'color', 'm');
else
	error('Unknown MATLAB version!');
end

title('(a) Training Data Distribution');
xlabel('x(t)'); ylabel('x(t-1)');
axis([-inf inf -inf inf]);
axis('square'); set(gca, 'box', 'on');

point_n = 51;
%x = linspace(min(trn_data(:,1)), max(trn_data(:,1)), point_n);
%y = linspace(min(trn_data(:,2)), max(trn_data(:,2)), point_n);
x = linspace(-3, 3, point_n);
y = linspace(-3, 3, point_n);
[xx, yy] = meshgrid(x, y);
zz = zeros(size(xx));
sigma = 0.2;
for i = 1:point_n;
	fprintf('i = %g\n', i);
	for j = 1:point_n,
		dist = abs(xx(i,j)+sqrt(-1)*yy(i,j)-...
			trn_data(:,1)-sqrt(-1)*trn_data(:,2));
		zz(i, j) = sum(exp(-(dist/sigma).^2/2));
	end
end

% Shift and scale such that min = 0 and max = 1
min_z = min(min(zz));
max_z = max(max(zz));
zz = (zz - min_z)/(max_z-min_z);
%save equdensi xx yy zz

subplot(2,3,2); mesh(xx, yy, zz);
axis([-inf inf -inf inf -inf inf]); set(gca, 'box', 'on');
view([-15, 60]);
%frot3d on;
shading interp;
xlabel('x(t)'); ylabel('x(t-1)'); title('(b) Training Data Density');

subplot(2,3,3); pcolor(xx, yy, zz);
shading interp;
hold on
[junk, h2] = contour(xx, yy, zz, 10, 'k');
hold off
axis square
xlabel('x(t)'); ylabel('x(t-1)'); title('(c) Density Contours');
shading interp; colormap(cool);
%frot3d on;

figure;
blackbg;
min_z = min(min(zz));
max_z = max(max(zz));
zlimit = [3*min_z-2*max_z, max_z];
mesh(xx, yy, zz);
hold on;
h1 = pcolor(xx, yy, zz);
% move down pcolor surface
tmp_z = get(h1, 'zdata');
set(h1, 'zdata', zlimit(1)*ones(size(tmp_z)));
[junk, h2] = contour(xx, yy, zz, 'k');
% move down contours
for i = 1:length(h2);
	tmp = get(h2(i), 'zdata');
	set(h2(i), 'zdata', zlimit(1)*ones(size(tmp)));
end
hold off
xlabel('x(t)'); ylabel('x(t-1)'); title('Training Data Density');
axis([-inf inf -inf inf zlimit]); set(gca, 'box', 'on');
shading interp; colormap(cool);
%frot3d on;
