% collect hair dryer data
% data format:
% [y(k) y(k-1) y(k-2) y(k-3) y(k-4)
%  u(k-1) u(k-2) u(k-3) u(k-4) u(k-5) u(k-6)]
load housing.dat
data_n = size(housing, 1);
data = housing;
input_name = str2mat('CRIM', 'ZN', 'INDUS', 'CHAS', ...
	'NOX', 'RM', 'AGE', 'DIS', 'RAD', 'TAX');
input_name = str2mat(input_name, ...
	'PTRATIO', 'B', 'LSTAT', 'MEDV');
trn_data_n = 300;	% No. of training data pairs
