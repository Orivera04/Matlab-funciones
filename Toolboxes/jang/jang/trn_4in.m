%function trn_4in(mf_n, epoch_n)

%if nargin < 2, epoch_n = 10; end
%if nargin < 1, mf_n = 2; end

epoch_n=10;
mf_n=2;

% load raw time series data
load mgdata.dat
time = mgdata(:, 1);
ts = mgdata(:, 2);
trn_data = zeros(500, 5);
chk_data = zeros(500, 5);

% prepare training data
start = 101;
trn_data(:, 1) = ts(start:start+500-1); 
start = start + 6;
trn_data(:, 2) = ts(start:start+500-1); 
start = start + 6;
trn_data(:, 3) = ts(start:start+500-1); 
start = start + 6;
trn_data(:, 4) = ts(start:start+500-1); 
start = start + 6;
trn_data(:, 5) = ts(start:start+500-1); 

% prepare checking data
start = 601;
chk_data(:, 1) = ts(start:start+500-1); 
start = start + 6;
chk_data(:, 2) = ts(start:start+500-1); 
start = start + 6;
chk_data(:, 3) = ts(start:start+500-1); 
start = start + 6;
chk_data(:, 4) = ts(start:start+500-1); 
start = start + 6;
chk_data(:, 5) = ts(start:start+500-1); 

% Swap the training and checking data sets
%tmp = trn_data;
%trn_data = chk_data;
%chk_data = tmp;

% generate FIS matrix
mf_type = 'gbellmf';
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
ss = 0.1;
mf_type = 'gbellmf';
tic;
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss nan nan], [1,1,1,1], chk_data);
toc;

figure('name', ...
	['ANFIS: Mackey-Glass time series prediction (file: ' mfilename ')'],...
	'number', 'off');
blackbg;
subplot(221);
tmp = [trn_error chk_error];
plot(tmp);
title('Error Curves');
axis([0 epoch_n min(tmp(:)) max(tmp(:))]);
legend('Training Error', 'Checking Error');

subplot(222);
plot(step_size);
title('Step Sizes');

subplot(223);
input = [trn_data(:, 1:4); chk_data(:, 1:4)];
anfis_output = evalfis(input, trn_out_fismat);
index = 125:1124;
plot(time(index), [ts(index) anfis_output]);
axis([min(time(index)) max(time(index)) min(ts(index)) max(ts(index))]);
title('Desired and ANFIS Outputs')

subplot(224);
diff = ts(index)-anfis_output;
plot(time(index), diff);
axis([min(time(index)) max(time(index)) min(diff) max(diff)]);
title('Prediction Errors')

figure('name', ...
	['ANFIS: Mackey-Glass time series prediction (file: ' mfilename ')'],...
	'number', 'off');
blackbg;
% plot final MF's on x, y, z, u
in_range = getfis(trn_out_fismat, 'inrange');
mf_type = getfis(trn_out_fismat, 'inmftypes');
mf_para = getfis(trn_out_fismat, 'inmfparams');
in_n = getfis(trn_out_fismat, 'numinputs');
in_mf_n = getfis(trn_out_fismat, 'NumInputMfs');
start = [0 cumsum(in_mf_n)] + 1;

subplot(221);
input_index = 1;
curr_in_range = in_range(input_index, :);
curr_mf_type = mf_type(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
curr_mf_para = mf_para(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
x = linspace(curr_in_range(1), curr_in_range(2), 101);
mf = evalmmf(x, curr_mf_para, curr_mf_type);
plot(x', mf');
axis([curr_in_range 0 1.2]);
title('Final MFs on Input 1, x(t - 18)');

subplot(222);
input_index = 2;
curr_in_range = in_range(input_index, :);
curr_mf_type = mf_type(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
curr_mf_para = mf_para(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
x = linspace(curr_in_range(1), curr_in_range(2), 101);
mf = evalmmf(x, curr_mf_para, curr_mf_type);
plot(x', mf');
axis([curr_in_range 0 1.2]);
title('Final MFs on Input 2, x(t - 12)');

subplot(223);
input_index = 3;
curr_in_range = in_range(input_index, :);
curr_mf_type = mf_type(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
curr_mf_para = mf_para(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
x = linspace(curr_in_range(1), curr_in_range(2), 101);
mf = evalmmf(x, curr_mf_para, curr_mf_type);
plot(x', mf');
axis([curr_in_range 0 1.2]);
title('Final MFs on Input 3, x(t - 6)');

subplot(224);
input_index = 4;
curr_in_range = in_range(input_index, :);
curr_mf_type = mf_type(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
curr_mf_para = mf_para(start(input_index): ...
	start(input_index)+in_mf_n(input_index)-1, :);
x = linspace(curr_in_range(1), curr_in_range(2), 101);
mf = evalmmf(x, curr_mf_para, curr_mf_type);
plot(x', mf');
axis([curr_in_range 0 1.2]);
title('Final MFs on Input 4, x(t)');

figure;
blackbg;
subplot(2,2,1); plot(tmp);
title('Error Curves');
axis([0 epoch_n min(tmp(:)) max(tmp(:))]);
xlabel('Epochs');
ylabel('Root-mean-squared Error')
cyclesty;
legend('Training Error', 'Checking Error');
