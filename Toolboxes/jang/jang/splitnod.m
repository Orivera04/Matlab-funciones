function [delta_e, split_var, split_value] = splitnod(node_index)
% SPLITNOD Split a CART node indexed by node_index.
%	Return change in error measure, split variable, and split value.

%	Roger Jang, 7-31-1995

% declare global variables
cartglob;

% get training data of this node
trn_data = all_trn_data(getdata(node_index), :);

% construct split matrix
% split(i, j) is j-th split value of i-th input variable
% split_n(i) is the number of possible splits of i-th variable

split = [];
split_n = zeros(in_var_n, 1);
for i = 1:in_var_n,
	split_of_a_var = splitval(trn_data, i+1);
	split_n(i) = length(split_of_a_var);
	if isempty(split_of_a_var),
		split_of_a_var = nan;
	end
	split = combine(split, split_of_a_var);
end

error_measure = inf*ones(size(split));

for i = 1:in_var_n,
	for j = 1:split_n(i),
		index1 = find(trn_data(:, i+1) < split(i,j));
		index2 = (1:size(trn_data, 1))';
		index2(index1) = [];
		data1 = trn_data(index1, :);
		data2 = trn_data(index2, :);
		error1 = emdata(data1);
		error2 = emdata(data2);
		error_measure(i, j) = error1 + error2;
	end
end

if size(error_measure, 2) ~= 1,
	[min_error_on_var, which_split] = min(error_measure');
else
	min_error_on_var = error_measure';
	which_split = ones(1, in_var_n);
end
[min_error, which_var] = min(min_error_on_var);

curr_error_measure = CART_table(node_index, 1);

delta_e = curr_error_measure - min_error; 
split_var = which_var;
split_value = split(which_var, which_split(which_var));

if delta_e < 0,
	keyboard;
end

