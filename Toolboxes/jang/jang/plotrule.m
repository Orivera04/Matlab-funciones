function plotrule(cart_table, range, node_index)
% PLOTRULE Plot decision boundaries of CART specified by cart_table.

%	Roger Jang, 7-31-95

if nargin < 3, node_index = 1; end
if nargin < 2, range = [-3 3 -3 3]; end

split_var = cart_table(node_index, 3);
split_value = cart_table(node_index, 4);
left_child = cart_table(node_index, 5);
right_child = cart_table(node_index, 6);

linewidth = 3;
if left_child ~= 0,
	if split_var == 1,
		line([split_value split_value], range(3:4), ...
			'linewidth', linewidth);
		range1 = [range(1) split_value range(3:4)];
		range2 = [split_value range(2:4)];
	else
		line(range(1:2), [split_value split_value], ...
			'linewidth', linewidth);
		range1 = [range(1:3) split_value];
		range2 = [range(1:2) split_value range(4)];
	end
	plotrule(cart_table, range1, left_child);
	plotrule(cart_table, range2, right_child);
end
