function getdata(node_index, data_index);
% SETDATA Set training data of a node in a CART.

%	Roger Jang, 7-31-1995

cartglob;
data_index = data_index(:)';
CART_table(node_index, 7:length(data_index)+6) = data_index;
