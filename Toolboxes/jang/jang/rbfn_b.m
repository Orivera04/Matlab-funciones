function [CENTER,SIGMA,W,RMSE] = ...
	rbfn(trn_data, rbfn_config, train_opt, disp_op)
% RBFN	Radial basis function networks
%	Type "rbfn" for a self demo.

%	Roger Jang, 1995


% Set up default input arguments
if nargin < 4, disp_opt = 1; end
if nargin < 3, train_opt = [0.001 0.001 0 1000 0]; end
if nargin < 2, rbfn_config = [1 6 1]; end
if nargin < 1,
	x = linspace(-1, 1, 51)';
	y = 0.6*sin(pi*x) + 0.3*sin(3*pi*x) + 0.1*sin(5*pi*x);
	trn_data = [x y];
end

error_goal = train_opt(1);	% Stop if RMSE is below error_goal
eta = train_opt(2);		% Learning rate
alpha = train_opt(3);		% Momentum term
max_epoch = train_opt(4);	% Max. training epochs
normalized_SD = train_opt(5);	% Normalized SD is used if this is 1
in_n = rbfn_config(1);		% Number of inputs
hidden_n = rbfn_config(2);	% Number of hidden units
out_n = rbfn_config(3);		% Number of outputs

[data_n, col_n] = size(trn_data);
if in_n + out_n ~= col_n,
	error('Given data mismatches given I/O numbers!');
end
X0 = trn_data(:, 1:in_n);
T = trn_data(:, in_n+1:in_n+out_n);

% ====== Initialize parameters
% Make sure all the centers are in the input ranges
% CENTER(i, j) is the j-th component of i-th center
input_range = max(X0) - min(X0);
CENTER = rand(hidden_n, in_n).*(ones(hidden_n, 1)*input_range) + ...
	ones(hidden_n, 1)*min(X0);
if in_n == 1,
	CENTER = linspace(min(X0), max(X0), hidden_n)';
end

% SIGMA(i) is the variance for i-th center
SIGMA = 0.02*ones(hidden_n, 1); 
SIGMA = 1/(2*length(CENTER)-2)/sqrt(2*log(2))*ones(hidden_n, 1); % for SISO
SIGMA = 1/(2*size(CENTER, 1)^(1/in_n)-2)/sqrt(2*log(2))*ones(hidden_n, 1);

rand('uniform');		% Uniform random number
weight_range = .5;		% Range for initial weights
W = weight_range*2*(rand(hidden_n,out_n) - 0.5);	
W = zeros(hidden_n, out_n);

RMSE = zeros(max_epoch, 1);	% Root mean squared error
dist = zeros(data_n, hidden_n);

for i = 1:max_epoch,
	% Find distance matrix: dist(i,j) = distance from data i to center j
	dist = vecdist(X0, CENTER);

	% Forward pass
	X1 = exp(-(dist.^2)./(2*ones(data_n,1)*(SIGMA.^2)'));	% hidden layer
	X2 = X1*W;					% output layer
	diff = T - X2;	% error

	% Check if finished 
	RMSE(i) = sqrt(sum(sum(diff.^2))/length(diff(:)));
	fprintf('Epoch %.0f:  RMSE = %.10g\n',i, RMSE(i));
	if RMSE(i) < error_goal, break; end

	% BP for output layer
	dE_dX2 = -(T - X2);	% dE/dX1
	dE_dW = X1'*dE_dX2;

	% BP for hidden layer (radial basis functions)
	dE_dX1 = dE_dX2*W';			% dE/dX1
	dX1_dSigma = X1.*(dist.^2./(ones(data_n,1)*(SIGMA.^3)'));
	dE_dSigma = sum(dE_dX1.*dX1_dSigma)';
	dE_dCenter = ((dE_dX1.*X1)'*X0-(dE_dX1.*X1)'*ones(data_n,in_n).*CENTER)./(SIGMA.^2*ones(1, in_n));

	% Simple steepest descent
	dW = -eta*dE_dW;
	dSigma = -eta*dE_dSigma;
	dCenter = -eta*dE_dCenter;
	W = W + dW;
	SIGMA = SIGMA + dSigma;
	CENTER = CENTER + dCenter;
end

if i < max_epoch,
	fprintf('Error goal reached after %g epochs.\n', i);
else
	fprintf('Max. no. of epochs (%g) reached.\n', max_epoch);
end
RMSE(i+1:max_epoch) = []; % Get rid of extra elements in RMSE.
fprintf('Final RMSE: %.10g\n', RMSE(i));
figure; plot(1:i, RMSE, '-', 1:i, RMSE, 'o');
xlabel('Epochs'); ylabel('RMSE (Root mean squared error)');
