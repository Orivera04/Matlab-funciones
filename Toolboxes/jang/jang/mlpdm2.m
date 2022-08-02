function [W1, W2, RMSE] = mlpdm2(trn_data, mlp_config, train_opt, disp_opt)
% MLPDM2 Demo of solving 2-input 1-output problem using MLP with
%	hyperbolic tangent activation.
%	MLPDM2 by itself is a demo of solving the XOR problem
%
%	See also TANMLP, MLPDM1.

% Roger Jang, Nov 12, 1996

% Set up default input arguments
if nargin < 4, disp_opt = 1; end
if nargin < 3, train_opt = [0.1 0.1 0.1 500 0]; end
if nargin < 2, mlp_config = [2 2 1]; end
if nargin < 1, trn_data = [-1 -1 -1; -1 1 1; 1 -1 1; 1 1 -1]; end

error_goal = train_opt(1);	% Stop if RMSE is below error_goal
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
normalized_SD = train_opt(5);	% Normalized SD is used if this is 1
in_n = mlp_config(1);		% Number of inputs
hidden_n = mlp_config(2);	% Number of hidden units
out_n = mlp_config(3);		% Number of outputs

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
epoch = 1;

point_n = 11;
p = linspace(min(trn_data(:,1)), max(trn_data(:,1)), point_n);
q = linspace(min(trn_data(:,2)), max(trn_data(:,2)), point_n);
[pp, qq] = meshgrid(p, q);
dense_input = [pp(:) qq(:)];

figure;
blackbg;

% Make everything interruptible
set(findobj(gcf,'Interrupt','no'), 'Interrupt','yes');

global mlpdm2_stop;
mlpdm2_stop = 0;
stopH = uicontrol('string', 'Stop', ...
	'callback', 'global mlpdm2_stop; mlpdm2_stop=1;', 'inter', 'yes');

while 1,
	% Forward pass
	X1 = tanh([X0 one]*W1);	% Output of layer 1 (hidden layer)
	X2 = tanh([X1 one]*W2);	% Output of layer 2 (output layer)
	diff = T - X2;	% error
	RMSE(epoch) = sqrt(sum(sum(diff.^2))/length(diff(:)));
	if disp_opt==1, 
		fprintf('epoch %.0f:  RMSE = %.3f\n',epoch, RMSE(epoch));
	end

	% Check if finished 
	if (RMSE(epoch)<error_goal | ...
		epoch==max_epoch | ...
		mlpdm2_stop), break; end

	% Backward pass for the output layer
	dE_dX2 = -2*(T - X2);	% dE/dX1
	dE_dW2 = [X1 one]'*(dE_dX2.*(1+X2).*(1-X2));
	% Backward pass for the hidden layer
	dE_dX1 = dE_dX2.*(1-X2).*(1+X2)*W2(1:hidden_n,:)';	% dE/dX1
	dE_dW1 = [X0 one]'*(dE_dX1.*(1+X1).*(1-X1));

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
%	eta = adjeta(eta, RMSE(1:epoch));

	% Animation
	dense_output = ...
	tanh([tanh([dense_input ones(point_n^2,1)]*W1) ones(point_n^2,1)]*W2);
	new_z = reshape(dense_output, point_n, point_n);
 	if epoch == 1;
		meshH = mesh(pp, qq, new_z);
		axis([min(trn_data(:,1)), max(trn_data(:,1)), ...
			min(trn_data(:,2)), max(trn_data(:,2)), ...
			min(trn_data(:,3)), max(trn_data(:,3))]);
		view([20 50]);
		set(meshH, 'erasemode', 'background');
		set(gca, 'box', 'on');
	else
		set(meshH, 'zdata', new_z);
	end
	drawnow;

	epoch = epoch + 1;
end

axis off; axis on;
RMSE(find(RMSE==-1)) = [];	% Get rid of extra elements in RMSE.
if disp_opt==1,
	fprintf('\nTotal number of epochs: %g\n', epoch);
	fprintf('Final RMSE: %g\n', RMSE(epoch));
	figure;
	blackbg;
	plot(1:length(RMSE), RMSE, '-', 1:length(RMSE), RMSE, 'o');
	xlabel('Epochs'); ylabel('RMSE (Root mean squared error)');
end
