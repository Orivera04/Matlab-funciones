function CART_table = cartmain(all_trn_data, rule_n);
% CARTMAIN Main routine for CART (regression only)

%	Roger Jang, 7-31-95

% declare global variables
clear global;
cartglob;

% collect training data
data_n = size(all_trn_data, 1);
all_trn_data = [(1:data_n)' all_trn_data];	% the first column is data index
in_var_n = size(all_trn_data, 2)-2;

node_n = 1;

% Fill in the first row of CART_table
% Column 7 and above: data index
% (This has to be set first in order to use emnode().
CART_table(1, 7:data_n+6) = 1:data_n;
[em, pred_out] = emnode(node_n);
% Column 1: error measure
CART_table(node_n, 1) = em;
% Column 2: predicted output 
CART_table(node_n, 2) = pred_out;
% Column 3: split variable 
CART_table(node_n, 3) = 0;
% Column 4: split value 
CART_table(node_n, 4) = 0;
% Column 5: left child 
CART_table(node_n, 5) = 0;
% Column 6: right child 
CART_table(node_n, 6) = 0;

for i = 2:rule_n,
	growtree;
end
