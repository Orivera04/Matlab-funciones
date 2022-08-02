tolerance = 0;			% Stop learning once RMSE is below tolerance
eta = 0.001;			% Learning rate
max_epoch = 1000;		% Max. training epochs
in_n = 1;			% Number of inputs
hidden_n = 6;			% Number of hidden units
out_n = 1;			% Number of outputs

weight_range = .5;		% Range for initial weights
%x = linspace(0, 1)';
%y = 4*x.*(1-x);
x = linspace(-1, 1, 51)';
y = 0.6*sin(pi*x) + 0.3*sin(3*pi*x) + 0.1*sin(5*pi*x);
trn_data = [x y];

[data_n, col_n] = size(trn_data);
IN = trn_data(:, 1:in_n);
target = trn_data(:, in_n+1:in_n+out_n);

% ====== Initialize parameters
% Make sure all the centers are in the input ranges
% CENTER(i, j) is the j-th component of i-th center
input_range = max(IN) - min(IN);
CENTER = rand(hidden_n, in_n).*(ones(hidden_n, 1)*input_range) + ...
	ones(hidden_n, 1)*min(IN);
if in_n == 1,
	CENTER = linspace(min(IN), max(IN), hidden_n)';
end

% SIGMA(i) is the variance for i-th center
SIGMA = 0.02*ones(hidden_n, 1); 
SIGMA = 1/(2*length(CENTER)-2)/sqrt(2*log(2))*ones(hidden_n, 1); % for SISO
SIGMA = 1/(2*size(CENTER, 1)^(1/in_n)-2)/sqrt(2*log(2))*ones(hidden_n, 1);

W = weight_range*2*(rand(hidden_n,out_n) - 0.5);	
W = zeros(hidden_n, out_n);

finished = 0;
epoch = 1;
RMSE = -ones(max_epoch, 1);	% Root mean squared error

dist = zeros(data_n, hidden_n);
while finished == 0
	% Find distance matrix: dist(i,j) = distance from data i to center j
	% This is a memory-intensive (but vectorized) way to do it. 
	aug_IN = IN((1:data_n)'*ones(1, hidden_n), :);
	aug_CENTER = CENTER(ones(data_n, 1)*(1:hidden_n), :);
	if in_n == 1,
		dist = abs(aug_IN-aug_CENTER);
	else
		dist = (sum((aug_IN-aug_CENTER)'.^2).^0.5)';
	end
	dist = reshape(dist, data_n, hidden_n);

	% Forward pass
	X1 = exp(-(dist.^2)./(2*ones(data_n, 1)*(SIGMA.^2)'));	% Output of hidden layer
	X2 = X1*W;					% Output of output layer
	diff = target - X2;	% error

	% BP for output layer
	dE_dX2 = -(target - X2);	% dE/dX1
	dE_dW = X1'*dE_dX2;
	dW = -eta*dE_dW;
	dW_old = dW;
	W = W + dW;

	% BP for hidden layer
	dE_dX1 = dE_dX2*W';			% dE/dX1
	dX1_dSigma = X1.*(dist.^2./(ones(data_n,1)*(SIGMA.^3)'));
	dE_dSigma = sum(dE_dX1.*dX1_dSigma)';
	dE_dCenter = ((dE_dX1.*X1)'*IN-(dE_dX1.*X1)'*ones(data_n, in_n).*CENTER)./(SIGMA.^2*ones(1, in_n));

	dSigma = -eta*dE_dSigma;
	dCenter = -eta*dE_dCenter;
	SIGMA = SIGMA + dSigma;
	CENTER = CENTER + dCenter;

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
	if in_n == 1;
	if epoch == 1,
		figure;
		blackbg;
		dataH = line(IN, target, 'linestyle', 'o', 'color', 'y', ...
			'erase', 'xor');
		nnH = line(IN, X2, 'color', 'm', 'linewidth', 3, ...
			'erase', 'xor');
		basisH = line(IN, X1, 'color', 'c', 'erase', 'xor');
		scaled_basisH = line(IN, X1*0, 'color', 'g', 'erase', 'xor');
		axis([min(IN),max(IN),min(-1,min(target)),max(1,max(target))]);
		set(gca, 'box', 'on');
		drawnow
	else
		set(nnH, 'ydata', X2);
		for k = 1:hidden_n,
			set(basisH(k), 'ydata', X1(:,k));
			set(scaled_basisH(k), 'ydata', X1(:,k)*W(k));
		end
		drawnow
	end
	end
	epoch = epoch + 1;
end

RMSE(find(RMSE==-1)) = [];	% Get rid of extra elements in RMSE.
fprintf('\nTotal number of epochs: %g\n', epoch-1);
fprintf('Final RMSE: %g\n', RMSE(epoch-1));
figure;
blackbg;
plot(1:length(RMSE), RMSE, '-', 1:length(RMSE), RMSE, 'o');
xlabel('Epochs'); ylabel('RMSE (Root mean squared error)');

% Plot desired and predicted output if SISO
if in_n == 1;
	figure;
	blackbg;
	plot(IN,target,'yo', IN, X2, 'm-', IN, X1, 'c-', IN, X1*diag(W), 'g-');
elseif in_n == 2;
	figure;
	blackbg;
	subplot(2,2,1); mesh(reshape(target, sqrt(data_n), sqrt(data_n)));
	title('Desired surface');
	axis([-inf inf -inf inf -inf inf]);
	subplot(2,2,2); mesh(reshape(X2, sqrt(data_n), sqrt(data_n)));
	title('Predicted surface');
	axis([-inf inf -inf inf -inf inf]);
end
