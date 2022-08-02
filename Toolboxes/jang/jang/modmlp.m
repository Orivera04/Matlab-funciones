function RMSE = modmlp(task, mlp_config, train_opt)
% MODMLP 
% MLP (multilayer perceptron) with modified sigmoidal functions 
% Roger Jang, Nov 6, 1995

% Set up default input arguments
if nargin < 3,
	train_opt = [0.1 0.1 0.8 500];
	if nargin < 2,
		mlp_config = [2 2 1];
		if nargin < 1,
			task = 'modxor'; % input-output-scaled data 
		end
	end
end

tolerance = train_opt(1); % Stop learning once RMSE is below tolerance
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
in_n = mlp_config(1);		% Number of inputs
hidden_n = mlp_config(2);	% Number of hidden units
out_n = mlp_config(3);		% Number of outputs

rand('uniform');		% Uniform random number
weight_range = .5;		% Range for initial weights
eval(['load ' task '.dat']);	% Load training data
eval(['trn_data = ' task ';']);	% Set "trn_data" to training data
[data_n, col_n] = size(trn_data);
if in_n + out_n ~= col_n,
	error('Given data mismatches given I/O numbers!');
end
IN = trn_data(:, 1:in_n);
target = trn_data(:, in_n+1:in_n+out_n);

% ====== Initialize weights
W1 = weight_range*2*(rand(in_n+1,hidden_n) - 0.5);	% The last row is bias
W2 = weight_range*2*(rand(hidden_n+1,out_n) - 0.5);	% The last row is bias 

dW1_old = zeros(size(W1));
dW2_old = zeros(size(W2));
one = ones(data_n, 1);
finished = 0;
epoch = 1;
RMSE = -ones(max_epoch, 1);	% Root mean squared error
point_n = 11;
p = linspace(-1, 1, point_n);
q = linspace(-1, 1, point_n);
[pp, qq] = meshgrid(p, q);
dense_input = [pp(:) qq(:)];

while finished == 0
	% Forward pass
	X1 = tanh([IN one]*W1);	% Output of layer 1 (hidden layer)
	X2 = tanh([X1 one]*W2);	% Output of layer 2 (output layer)
	diff = target - X2;	% error

	% BP for output layer
	dE_dX2 = -(target - X2);	% dE/dX1
	dE_dW2 = [X1 one]'*(dE_dX2.*(1+X2).*(1-X2));
	dW2 = -eta*dE_dW2 + alpha*dW2_old;
	dW2_old = dW2;
	W2 = W2 + dW2;

	% BP for hidden layer
	dE_dX1 = dE_dX2.*(1-X2).*(1+X2)*W2(1:hidden_n,:)';	% dE/dX1
	dE_dW1 = [IN one]'*(dE_dX1.*(1+X1).*(1-X1));
	dW1 = -eta*dE_dW1 + alpha*dW1_old;
	dW1_old = dW1;
	W1 = W1 + dW1;

	% Check if finished 
	RMSE(epoch) = sqrt(sum(sum(diff.^2))/length(diff(:)));
	if RMSE(epoch) < tolerance
		finished = 1;
	end

	% Print out RMSE 
	fprintf('epoch %.0f:  RMSE = %.3f\n',epoch, RMSE(epoch));

	% Jump out of loop if max epoch is reached 
	if epoch == max_epoch,
		break;
	end

	% Animation
	if nargin == 0,
		dense_output = tanh([tanh([dense_input ones(point_n^2,1)]*W1) ones(point_n^2,1)]*W2);
		new_z = reshape(dense_output, point_n, point_n);
 		if epoch == 1;
			meshH = mesh(pp, qq, new_z);
			axis([-1 1 -1 1 -1 1]);
			view([20 50]);
			set(meshH, 'erasemode', 'background');
		else
			set(meshH, 'zdata', new_z);
		end
		drawnow;
	end

	epoch = epoch + 1;
end

set(gca, 'box', 'on');
RMSE(find(RMSE==-1)) = [];	% Get rid of extra elements in RMSE.
weight_file = [task '.wts'];
eval(['save ',weight_file,' W1 W2']);	% Save the trained weights to a file
fprintf('\nTotal number of epochs: %g\n', epoch-1);
fprintf('Final RMSE: %g\n', RMSE(epoch-1));
figure; plot(1:length(RMSE), RMSE, '-', 1:length(RMSE), RMSE, 'o');
xlabel('Epochs'); ylabel('RMSE (Root mean squared error)');
