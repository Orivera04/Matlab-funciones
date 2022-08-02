function [W1, W2, RMSE] = ekfmlp(trn_data, mlp_config, train_opt, disp_opt)
% SEQMLP On-line extended Kalman filter training for MLP with hyperbolic tangent activation.
%	[W1, W2, RMSE] = ekfmlp(trn_data, mlp_config, train_opt).
%
%	See also MLPDM1 and MLPDM2.

% Roger Jang, Feb 6, 1999

% Set up default input arguments
if nargin < 4, disp_opt = 1; end
if nargin < 3, train_opt = [0.1 0.01 0.1 500]; end
if nargin < 2, mlp_config = [2 2 1]; end
if nargin < 1, trn_data = [-1 -1 -1; -1 1 1; 1 -1 1; 1 1 -1]; end

error_goal = train_opt(1);	% Stop if batch RMSE is below error_goal
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
in_n = mlp_config(1);		% Number of inputs
hidden_n = mlp_config(2);	% Number of hidden units
out_n = mlp_config(3);		% Number of outputs

weight_range = .5;		% Range for initial weights
[data_n, col_n] = size(trn_data);
if in_n + out_n ~= col_n,
	error('Given data mismatches given I/O numbers!');
end
INPUT = trn_data(:, 1:in_n);			% input
TARGET = trn_data(:, in_n+1:in_n+out_n);	% target

% ====== Initialize random weights
W1 = weight_range*2*(randn(in_n+1,hidden_n) - 0.5);	% last row: bias
W2 = weight_range*2*(randn(hidden_n+1,out_n) - 0.5);	% last row: bias
% ====== Initialize zero weights
W1 = weight_range*2*(zeros(in_n+1,hidden_n) - 0.5);	% last row: bias
W2 = weight_range*2*(zeros(hidden_n+1,out_n) - 0.5);	% last row: bias
dW1_old = zeros(size(W1));
dW2_old = zeros(size(W2));
RMSE = -ones(max_epoch, 1);	% Root mean squared error
% ====== Variables for extended Kalman filtering
alpha = 1e6;
W = [W1(:); W2(:)];
param_n = length(W);
P = alpha*eye(param_n, param_n);
lambda = 0.999;	% Forgetting factor

for i = 1:max_epoch,
    for j = 1:data_n,
	X0 = INPUT(j,:);
	T = TARGET(j,:);

	% Forward pass
	X1 = tanh([X0 1]*W1);	% Output of layer 1 (hidden layer)
	X2 = tanh([X1 1]*W2);	% Output of layer 2 (output layer)

	% Backward pass for the output layer
	dE_dX2 = -2*(T - X2);	% dE/dX1
	dE_dW2 = [X1 1]'*(dE_dX2.*(1+X2).*(1-X2));
	% Backward pass for the hidden layer
	dE_dX1 = dE_dX2.*(1-X2).*(1+X2)*W2(1:hidden_n,:)';	% dE/dX1
	dE_dW1 = [X0 1]'*(dE_dX1.*(1+X1).*(1-X1));

	% Update parameters using online simple gradient descent
	%dW2 = -eta*dE_dW2 + alpha*dW2_old;
	%dW1 = -eta*dE_dW1 + alpha*dW1_old;
	%W2 = W2 + dW2;
	%W1 = W1 + dW1;
	%dW2_old = dW2;
	%dW1_old = dW1;

	% ====== Update parameters using online extended Kalman filtering 
	a = [dE_dW1(:); dE_dW2(:)]; 
	y = T-X2; 
	P = (P - P*a*a'*P/(lambda+a'*P*a))/lambda;
	W = W + P*a*(y-a'*W);
	% Reshape the weight vector
	W1 = reshape(W(1:(in_n+1)*(hidden_n)), in_n+1, hidden_n);
	W2 = reshape(W((in_n+1)*(hidden_n)+1:end), hidden_n+1, out_n);
    end
    % Compute the batch RMSE error
    X1 = tanh([INPUT ones(data_n,1)]*W1);% Output of layer 1 (hidden layer)
    X2 = tanh([X1 ones(data_n,1)]*W2);	% Output of layer 2 (output layer)
    diff = TARGET - X2;	% error
    RMSE(i) = sqrt(sum(sum(diff.^2))/length(diff(:)));
    if disp_opt==1, 
	fprintf('epoch %.0f:  RMSE = %.3f\n',i, RMSE(i));
    end
    % Check if finished 
    if RMSE(i)<error_goal, break; end
end

RMSE(find(RMSE==-1)) = [];	% Get rid of extra elements in RMSE.

if disp_opt==1,
	fprintf('\nTotal number of epochs: %g\n', i);
	fprintf('Final RMSE: %g\n', RMSE(i));
	plot(1:length(RMSE), RMSE, '-', 1:length(RMSE), RMSE, 'o');
	xlabel('Epochs'); ylabel('Batch RMSE');
end
