% Cretae training data
numPts = 31;
x = linspace(-1, 1, numPts)';
y = 0.6*sin(pi*x) + 0.3*sin(3*pi*x) + 0.1*sin(5*pi*x);
trn_data = [x y];

hidden_n = 10;
train_opt = [0.001 0.01 0.1 5000];
mlp_config = [1 3 1];
task = 'SISO'; % Default data file is bipxor.dat 

tolerance = train_opt(1);	% Stop learning once RMSE is below tolerance
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
in_n = mlp_config(1);		% Number of inputs
hidden_n = mlp_config(2);	% Number of hidden units
out_n = mlp_config(3);		% Number of outputs

rand('uniform');		% Uniform random number
weight_range = .5;		% Range for initial weights
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
point_n = 101;
dense_input = linspace(-1, 1, point_n)';

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
	dense_output = tanh([tanh([dense_input ones(point_n,1)]*W1) ones(point_n,1)]*W2);
 	if epoch == 1;
		plot(x, y, 'go');
		axis([-1 1 -1 1]);
		lineH = line(dense_input, dense_output);
		set(lineH, 'erasemode', 'xor');
	else
		set(lineH, 'ydata', dense_output);
	end
	drawnow;

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
