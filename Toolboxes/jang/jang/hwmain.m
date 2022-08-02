function out = hwmain(case_n, random_seed)
%HWMAIN Performance evaluation of MLP learning strategies.
%	This file is used to evaluate various MLP learning strategies
%	for one of the homework in CS5652.
%	You are only allow to change lines 19, 20, and 21.

%	Roger Jang, Nov 12, 1996

if nargin < 2, random_seed = 0; end
if nargin < 1 case_n = 10; end

datafile = 'encode3.dat';
index = findstr(datafile, '.');
eval(['load ', datafile]);
eval(['trn_data = ', datafile(1:index-1) ';']);
mlp_config = [8 3 8];
error_goal = 0.1;	% Stop if RMSE is below error_goal
% ====== Don't change anything above this line.
eta = 0.01;		% eta (or kappa) for tanmlp.m
alpha = 0.0;		% Momentum term
normalized_SD = 0;	% 0 for simple SD; 1 for normalized SD
% ====== Don't change anything after this line.
max_epoch = 1000;	% Max. training epochs
train_opt = [error_goal eta alpha max_epoch normalized_SD];
disp_opt = 0;
rand('seed', random_seed);
RMSE = nan*ones(max_epoch, case_n);
epoch_n = zeros(case_n, 1);

for i = 1:case_n,
	[W1, W2, rmse] = tanmlp(trn_data, mlp_config, train_opt, disp_opt);
	epoch_n(i) = length(rmse);
	RMSE(1:epoch_n(i), i) = rmse;
	fprintf('%d/%d ---> %d epochs\n', i, case_n, epoch_n(i));
end
index = find(epoch_n<500);
finish_n = length(index);
ave_epoch = sum(epoch_n(index))/finish_n;
unfinish_n = case_n - finish_n;
fprintf('%d (%.0f%%) NNs finish the task, average epochs = %.2f.\n', ...
	finish_n, finish_n/case_n*100, ave_epoch);
fprintf('%d (%.0f%%) NNs couldn''t finish the task in %d epochs.\n', ...
	unfinish_n, unfinish_n/case_n*100, max_epoch); 
out = sum(epoch_n)/case_n;
fprintf('Performance index = %.2f epochs\n', out);
plot(RMSE);
axis([-inf inf 0 inf]);
xlabel('Number of Epochs');
ylabel('RMSE (Root-Mean-Squared Error)');
