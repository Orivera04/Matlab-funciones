function data_index = getdata(node_index);
% GETDATA Get training data of a CART node indexed by node_index.

%	Roger Jang, 7-31-1995

cartglob;
data_index = CART_table(node_index, 7:size(CART_table, 2));
data_index(find(data_index==0)) = [];
