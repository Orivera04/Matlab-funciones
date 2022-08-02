function [em, pred_out] = emnode(node_index)
% CARTEM Error measure for a CART node indexed by node_index.

%	Roger Jang, 7-31-1995

if nargin == 0,
	error('Need a node index as an input argument!');
end 

% declare global variables
cartglob;

% training data for this node
trn_data = all_trn_data(getdata(node_index), :);

% predicted output
pred_out = mean(trn_data(:, size(trn_data, 2)));

% error measure (MSE)
em = emdata(trn_data);
