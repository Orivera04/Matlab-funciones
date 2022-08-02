function out = usecart(data, CART_table)
% USECART Use a CART tree.

%	Roger Jang, 7-31-1995

data_n = size(data, 1);
out = zeros(data_n, 1);

for i = 1:data_n,
	node = 1;
	while CART_table(node, 5) ~= 0,
		split_var = CART_table(node, 3);
		split_value = CART_table(node, 4);
		left_child = CART_table(node, 5);
		right_child = CART_table(node, 6);
		if data(i, split_var) < split_value,
			node = left_child;
		else
			node = right_child;
		end
	end
	out(i) = CART_table(node, 2);
end
