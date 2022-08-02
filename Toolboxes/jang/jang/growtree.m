function growtree
% GROWTREE Grow tree by splitting a terminal node of a CART.
%	Each call of GROWTREE adds two new entry to CART_table. 

%	Roger Jang, 7-31-1995

% declare global variable
cartglob;

% Find terminal node
terminal_node = find(CART_table(:,5)==0);

% find the terminal node with max. delta_e
delta_e = zeros(size(terminal_node));
split_var = zeros(size(terminal_node));
split_value = zeros(size(terminal_node));
for i = 1:length(terminal_node),
	[delta_e(i) split_var(i) split_value(i)] = ...
		splitnod(terminal_node(i));
end

[max_delta_e, index] = max(delta_e);
node_to_split = terminal_node(index);

CART_table(node_to_split, 3) = split_var(index);	% split variable
CART_table(node_to_split, 4) = split_value(index);	% split value
CART_table(node_to_split, 5) = node_n+1;		% left child
CART_table(node_to_split, 6) = node_n+2;		% right child

% find data index for each of the child node
data_index = getdata(node_to_split);
trn_data = all_trn_data(data_index, :);
data1 = find(trn_data(:,split_var(index)+1) < split_value(index));
data2 = 1:size(trn_data, 1);
data2(data1) = [];
data_index1 = trn_data(data1, 1);
data_index2 = trn_data(data2, 1);

% create a row in CART_table for the left child
node_n = node_n + 1;
setdata(node_n, data_index1)
[em, pred_out] = emnode(node_n);
CART_table(node_n, 1) = em;
CART_table(node_n, 2) = pred_out;

% create a row in CART_table for the right child
node_n = node_n + 1;
setdata(node_n, data_index2)
[em, pred_out] = emnode(node_n);
CART_table(node_n, 1) = em;
CART_table(node_n, 2) = pred_out;

fprintf('Splitting node %g (%g) into node %g (%g) and %g (%g)...\n', ...
	node_to_split, length(getdata(node_to_split)), ...
	node_n-1, length(getdata(node_n-1)), ...
	node_n, length(getdata(node_n)));
