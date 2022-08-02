data = [ ...
	0.2 0.1 0;
	0.35 0.7 1;
	0.5 0.3 0;
	0.7 0.9 1;
	0.9 0.5 1];

data_n = size(data, 1);
in_n = 2;
index1 = find(data(:, in_n+1)==0);
index2 = find(data(:, in_n+1)==1);
data1 = data(index1, :);
data2 = data(index2, :);
subplot(2,2,1);
plot(data1(:,1), data1(:,2), 'x', ...
	data2(:,1), data2(:,2), 'o');
axis square;
axis([0 1 0 1]);
xlabel('x'); ylabel('y');
title('o: class 1, x: class 2');


x = sort(data(:, 1));
x(find(diff(x)==0)) = [];	% remove repeated items
sx = diff(x)/2 + x(1:length(x)-1);
for i = 1:length(sx),
	line([sx(i) sx(i)], [0 1], ...
		'color', 'g', 'linestyle', ':');
end
y = sort(data(:, 2));
y(find(diff(y)==0)) = [];	% remove repeated items
sy = diff(y)/2 + y(1:length(y)-1);
for i = 1:length(sy),
	line([0 1], [sy(i) sy(i)], ...
		'color', 'g', 'linestyle', ':');
end

% get rid of extra ticks
set(gca, 'xtick', [0 1]);
set(gca, 'ytick', [0 1]);

% impurity function
impurity_fcn = 'gini';
impurity_fcn = 'entropy';

I = feval(impurity_fcn, [size(data1, 1) size(data2, 1)]);
delta_I = zeros(2*data_n-2, 1);

% splits along x
for i = 1:length(sx),
	text(sx(i), 0, ['s', int2str(i)], ...
		'horizon', 'center', 'vertical', 'top');
	index_l = find(data(:, 1) < sx(i));
	index_r = find(data(:, 1) > sx(i));
	data_l = data(index_l, :);
	data_r = data(index_r, :);
	data_l_n = size(data_l, 1);
	data_r_n = size(data_r, 1);
	I_l = feval(impurity_fcn, ...
		[sum(data_l(:,in_n+1)==0) sum(data_l(:,in_n+1)==1)]);
	I_r = feval(impurity_fcn, ...
		[sum(data_r(:,in_n+1)==0) sum(data_r(:,in_n+1)==1)]);
	delta_I(i) = I -(data_l_n*I_l + data_r_n*I_r)/data_n; 
end

% splits along y
for i = 1:length(sy),
	text(0, sy(i), ['s', int2str(i+length(sx))], ...
		'horizon', 'right', 'vertical', 'middle');
	index_l = find(data(:, 2) < sy(i));
	index_r = find(data(:, 2) > sy(i));
	data_l = data(index_l, :);
	data_r = data(index_r, :);
	data_l_n = size(data_l, 1);
	data_r_n = size(data_r, 1);
	I_l = feval(impurity_fcn, ...
		[sum(data_l(:,in_n+1)==0) sum(data_l(:,in_n+1)==1)]);
	I_r = feval(impurity_fcn, ...
		[sum(data_r(:,in_n+1)==0) sum(data_r(:,in_n+1)==1)]);
	delta_I(i+length(sx)) = I -(data_l_n*I_l + data_r_n*I_r)/data_n; 
end

I
delta_I
