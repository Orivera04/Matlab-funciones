function [W1, W2, RMSE] = tanmlp(trn_data, mlp_config, train_opt, disp_opt)
% TANMLP Steepest descent for MLP with hyperbolic tangent activation
%	and a linear output element.
%	[W1, W2, RMSE] = tanmlp(trn_data, mlp_config, train_opt).
%
%	See also MLPDM1 and MLPDM2.

% Roger Jang, Nov 6, 1995

% Set up default input arguments
if nargin < 4, disp_opt = 1; end
if nargin < 3, train_opt = [0.1 0.1 0.1 500 0 1]; end
if nargin < 2, mlp_config = [2 2 1]; end
if nargin < 1, trn_data = [-1 -1 -1; -1 1 1; 1 -1 1; 1 1 -1]; end

error_goal = train_opt(1);	% Stop if RMSE is below error_goal
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
normalized_SD = train_opt(5);	% Normalized SD is used if this is 1
debug = train_opt(6);		% Check gradient vector
in_n = mlp_config(1);		% Number of inputs
hidden_n = mlp_config(2);	% Number of hidden units
out_n = mlp_config(3);		% Number of outputs

rand('uniform');		% Uniform random number
weight_range = .5;		% Range for initial weights
[data_n, col_n] = size(trn_data);
if in_n + out_n ~= col_n,
	error('Given data mismatches given I/O numbers!');
end
X0 = trn_data(:, 1:in_n);		% input
T = trn_data(:, in_n+1:in_n+out_n);	% target

% ====== Initialize weights
W1 = weight_range*2*(rand(in_n+1,hidden_n) - 0.5);	% last row: bias
W2 = weight_range*2*(rand(hidden_n+1,out_n) - 0.5);	% last row: bias
dW1_old = zeros(size(W1));
dW2_old = zeros(size(W2));
one = ones(data_n, 1);
RMSE = -ones(max_epoch, 1);	% Root mean squared error
if debug==1,
	error_W1 = zeros(max_epoch, 1);
	error_W2 = zeros(max_epoch, 1);
end

for i = 1:max_epoch,
	% Forward pass
	X1 = tanh([X0 one]*W1);	% Output of layer 1 (hidden layer)
	X2 = [X1 one]*W2;	% Output of layer 2 (output layer)
	diff = T - X2;	% error
	RMSE(i) = sqrt(sum(sum(diff.^2))/length(diff(:)));
	if disp_opt==1, 
		fprintf('epoch %.0f:  RMSE = %.3f\n',i, RMSE(i));
	end

	% Check if finished 
	if RMSE(i)<error_goal, break; end

	% Backward pass for the output layer
	dE_dX2 = -2*(T - X2);	% dE/dX1
	dE_dW2 = [X1 one]'*dE_dX2;
	% Backward pass for the hidden layer
	dE_dX1 = dE_dX2.*(1-X2).*(1+X2)*W2(1:hidden_n,:)';	% dE/dX1
	dE_dW1 = [X0 one]'*(dE_dX1.*(1+X1).*(1-X1));

	if debug==1,
		E = sum(sum(diff.^2));
		% gradient checking for W1
		delta = 1e-8;
		num_dE_dW1 = zeros(size(W1));
		for j = 1:length(W1(:));
			new_W1 = W1;
			new_W1(j) = new_W1(j)+delta;
			new_X1 = tanh([X0 one]*new_W1);
			new_X2 = [new_X1 one]*W2;
			new_diff = T - new_X2;	% error
			new_E = sum(sum(new_diff.^2));
			num_dE_dW1(j) = (new_E-E)/delta;
		end
	%	tmp = max(max(abs(dE_dW1-num_dE_dW1)));
		error_leng = sqrt(sum((dE_dW1(:)-num_dE_dW1(:)).^2));
		grad_leng = sqrt(sum((dE_dW1(:)).^2));
		error_W1(i) = error_leng/grad_leng*100;
		fprintf('===> Length of W1 grad error = %g (%.2g%%)\n', ...
			error_leng, error_W1(i));
	
		% gradient checking for W2
		num_dE_dW2= zeros(size(W2));
		for j = 1:length(W2(:));
			new_W2 = W2;
			new_W2(j) = new_W2(j)+delta;
			new_X1 = tanh([X0 one]*W1);
			new_X2 = [new_X1 one]*new_W2;
			new_diff = T - new_X2;	% error
			new_E = sum(sum(new_diff.^2));
			num_dE_dW2(j) = (new_E-E)/delta;
		end
	%	tmp = max(max(abs(dE_dW2-num_dE_dW2)));
		error_leng = sqrt(sum((dE_dW2(:)-num_dE_dW2(:)).^2));
		grad_leng = sqrt(sum((dE_dW2(:)).^2));
		error_W2(i) = error_leng/grad_leng*100;
		fprintf('===> Length of W2 grad error = %g (%.2g%%)\n', ...
			error_leng, error_W2(i));
	end

	if normalized_SD == 0,
		leng = 1; % Simple steepest descent
	else
		leng = norm([dE_dW1(:); dE_dW2(:)]); % Normalized SD
	end
	dW2 = -eta*dE_dW2/leng + alpha*dW2_old;
	dW1 = -eta*dE_dW1/leng + alpha*dW1_old;
	W2 = W2 + dW2;
	W1 = W1 + dW1;
	dW2_old = dW2;
	dW1_old = dW1;

	% Update learning rate (or step size if normalized SD is used)
	eta = adjeta(eta, RMSE(1:i));
end

RMSE(find(RMSE==-1)) = [];	% Get rid of extra elements in RMSE.

if disp_opt==1,
	fprintf('\nTotal number of epochs: %g\n', i);
	fprintf('Final RMSE: %g\n', RMSE(i));
	figure; plot(1:length(RMSE), RMSE, '-', 1:length(RMSE), RMSE, 'o');
	xlabel('Epochs'); ylabel('RMSE');
	if debug==1,
		error_W1(i+1:max_epoch) = [];
		error_W2(i+1:max_epoch) = [];
		figure; plot(1:i, error_W1, 1:i, error_W2);
		xlabel('Epochs'); ylabel('Percentage error (%)');
	end
end
