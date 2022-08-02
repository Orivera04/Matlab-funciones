% var_index is defined after running select.m

% ====== training option
mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 100;
ss = 0.01;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% ====== get training and checking data
input_n = length(var_index)-1;
t_data = trn_data(:, var_index);
c_data = chk_data(:, var_index);

% ====== generate initial FIS matrix
in_fismat = genfis1(t_data, mf_n, mf_type);

% ====== start training
if isempty(c_data),
[trn_out_fismat trn_error step_size] = ...
	anfis(t_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate]);
else
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(t_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	nan, c_data);
end

% ====== display the result
genfig(['ANFIS: ' num2str(input_n) '-input system']);

subplot(221);
if isempty(c_data), tmp = [trn_error];
else tmp = [trn_error chk_error]; end
[a, b] = min(chk_error);
plot((1:epoch_n)', tmp, b, a, 'go');
axis([0 epoch_n min(tmp(:)) max(tmp(:))]);
title('error curves');
xlabel('epoch number');

subplot(222);
plot(step_size);
axis([0 epoch_n min(step_size)-ss max(step_size)+ss]);
title('step sizes');
xlabel('epoch number');

% plot of training data
subplot(223);
plot(t_data(:,1), t_data(:, 2), 'yo', c_data(:,1), c_data(:, 2), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(var_name(var_index(1), :)));
ylabel(deblank(var_name(var_index(2), :)));
title('trainind (o) and checking (x) data');

y_hat = evalfis(t_data, chk_out_fismat);
subplot(224);
plot([y_hat t_data(:, size(t_data,2))]);
xlabel('data index');
ylabel(deblank(var_name(var_index(input_n+1), :)));
title('ANFIS Output');

% == set the right variable name
for i=1:input_n,
	chk_out_fismat = setfis(chk_out_fismat, ...
		'input', i, 'name', deblank(var_name(var_index(i), :)));
end
chk_out_fismat = setfis(chk_out_fismat, ...
	'output', 1, 'name', deblank(var_name(size(var_name, 1), :)));

if input_n == 2, dispmf; dispsurf;
elseif input_n == 3, surfview(chk_out_fismat); end

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
