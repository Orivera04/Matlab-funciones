input_index = [4 6];	% obtained from mpgpick2.m
loadmpg;

if exist('input_index') ~= 1,
	error('You should run "mpgpick2" first.');
	return;
end

% ====== training option
mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 100;
ss = 0.01;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% ====== get training and checking data
input_n = length(input_index);
t_data = data(1:2:size(data,1), [input_index size(data,2)]);
c_data = data(2:2:size(data,1), [input_index size(data,2)]);

% ====== generate initial FIS matrix
in_fismat = genfis1(t_data, mf_n, mf_type);

% ====== start training
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(t_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[1,1,1,1], c_data);
% ====== display the result
%genfig(['ANFIS: ' num2str(input_n) '-input system']);

[a, b] = min(chk_error);
%subplot(2,2,1);
blackbg;
plot(1:epoch_n, trn_error, '-', ...
	1:epoch_n, chk_error, '-', ...
	b, a, 'go');
axis([-inf inf -inf inf]);
legend('training error curve', 'checking error curve', ...
	'min. checking error');
xlabel('Epoch numbers');
ylabel('RMS errors');
title('Training (Solid) and Checking (Dotted) Error Curves');

% ====== set the right variable name for chk_out_fismat
for i=1:input_n,
	chk_out_fismat = setfis(chk_out_fismat, ...
		'input', i, 'name', deblank(input_name(input_index(i), :)));
end
chk_out_fismat = setfis(chk_out_fismat, ...
	'output', 1, 'name', deblank(input_name(size(input_name, 1), :)));

% ======= display surface
if input_n == 2,
	figure;
	blackbg;
	gensurf(chk_out_fismat);
	set(gca, 'box', 'on');
%	frot3d on
else
	surfview(chk_out_fismat);
end

% ======= display step size
figure;
blackbg;
plot(step_size);
axis([0 epoch_n min(step_size)-ss max(step_size)+ss]);
title('step sizes');
xlabel('epoch number');

% ======= display data distribution
%subplot(223);
%figure
%blackbg;
%plot(t_data(:,1), t_data(:, 2), 'yo', c_data(:,1), c_data(:, 2), 'rx');
%axis([-inf inf -inf inf]);
%xlabel(deblank(input_name(input_index(1), :)));
%ylabel(deblank(input_name(input_index(2), :)));
%title('trainind (o) and checking (x) data');

% ====== Calculate training RMSE and test RMSE
tmp = evalfis(t_data, trn_out_fismat);
e1 = norm(tmp-t_data(:, size(t_data,2)))/sqrt(size(t_data, 1));
tmp = evalfis(c_data, trn_out_fismat);
e2 = norm(tmp-c_data(:, size(c_data,2)))/sqrt(size(c_data, 1));
fprintf('At min. training error,\n');
fprintf('\ttraining RMSE = %g, checking RMSE = %g\n', e1, e2); 

tmp = evalfis(t_data, chk_out_fismat);
e1 = norm(tmp-t_data(:, size(t_data,2)))/sqrt(size(t_data, 1));
tmp = evalfis(c_data, chk_out_fismat);
e2 = norm(tmp-c_data(:, size(c_data,2)))/sqrt(size(c_data, 1));
fprintf('At min. checking error,\n');
fprintf('\ttraining RMSE = %g, checking RMSE = %g\n', e1, e2); 
