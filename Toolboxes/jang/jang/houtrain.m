% This file should be run after drypick?.m
% input_index is defined after running drypick?.m

houdata;

%input_index = [6 13];		% obtain from houpick2.m
%input_index = [6 11 13];	% obtain from houpick3.m
%input_index = [6 10 11 13];	% obtain from houpick4.m

if exist('input_index') ~= 1,
	fprintf('The variable "input_index" is not defined.\n');
	fprintf('Run "drypick?.m" to find "input_index" first.\n');
	return;
end

mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 100;
ss = 0.01;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% collect training data
trn_data = data(1:trn_data_n, [input_index, size(data,2)]);
chk_data = data(trn_data_n+1:size(data,1), [input_index, size(data,2)]);

% generate FIS matrix
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
if isempty(chk_data),
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate]);
else
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	nan, chk_data);
end

% Display the result
close all; figure;
%y_hat = evalfis(data(:,input_index), trn_out_fismat);
y_hat = evalfis(data(:,input_index), chk_out_fismat);

subplot(2,2,1);
if isempty(chk_data),
	tmp = [trn_error];
else
	tmp = [trn_error chk_error];
end
[a, b] = min(chk_error);
plot(1:epoch_n, trn_error, '-', ...
     1:epoch_n, chk_error, '.', ...
     1:epoch_n, chk_error, '-', ...
     b, a, 'go');
xlabel('Epochs');
ylabel('RMSE');
title('(a) Error Curves');
legend('Training Errors', 'Test Errors');

% plot of training and checking data distribution
if length(input_index) == 2,
subplot(2,2,2);
plot(trn_data(:,1), trn_data(:, 2), 'yo', ...
	chk_data(:,1), chk_data(:, 2), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(2), :)));
title('(b) Data Distribution');
legend('Trn. data', 'Chk. data');

output = trn_data(:, size(trn_data,2));
subplot(2,2,3);
point_n = 50;
x = linspace(min(trn_data(:,1)), max(trn_data(:,1)), point_n);
y = linspace(min(trn_data(:,2)), max(trn_data(:,2)), point_n);
[xx, yy] = meshgrid(x, y);
zz = evalfis([xx(:) yy(:)], chk_out_fismat);
index = find(zz > max(output));
zz(index) = max(output)*ones(size(index));
index = find(zz < min(output));
zz(index) = min(output)*ones(size(index));
mesh(xx, yy, reshape(zz, point_n, point_n));
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(2), :)));
zlabel('y(t)');
title('(d) ANFIS Surface');
view([-38 35]);

elseif length(input_index) == 3,
subplot(2,2,2);
plot(trn_data(:,1), trn_data(:, 2), 'yo', ...
	chk_data(:,1), chk_data(:, 2), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(2), :)));
title('(b) Data Distribution');
legend('Trn. data', 'Chk. data');
subplot(2,2,3);
plot(trn_data(:,1), trn_data(:, 3), 'yo', ...
	chk_data(:,1), chk_data(:, 3), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(3), :)));
title('(c) Data Distribution');
legend('Trn. data', 'Chk. data');
subplot(2,2,4);
plot(trn_data(:,2), trn_data(:, 3), 'yo', ...
	chk_data(:,2), chk_data(:, 3), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(2), :)));
ylabel(deblank(input_name(input_index(3), :)));
title('(d) Data Distribution');
legend('Trn. data', 'Chk. data');
end

figure;
if length(input_index) == 2,
	% plot initial MFs on x and y
	subplot(221);
	plotmf(in_fismat, 'input', 1);
	subplot(222);
	plotmf(in_fismat, 'input', 2);
	subplot(223);
	plotmf(chk_out_fismat, 'input', 1);
	subplot(224);
	plotmf(chk_out_fismat, 'input', 2);
	delete(findobj(gcf, 'type', 'text'));
	subplot(221);
	title('Initial MFs on X');
	subplot(222);
	title('Initial MFs on Y');
	subplot(223);
	title('Final MFs on X');
	subplot(224);
	title('Final MFs on Y');
elseif length(input_index) == 3,
	% plot initial MFs on x and y
	subplot(221);
	plotmf(in_fismat, 'input', 1);
	subplot(222);
	plotmf(chk_out_fismat, 'input', 1);
	subplot(223);
	plotmf(chk_out_fismat, 'input', 2);
	subplot(224);
	plotmf(chk_out_fismat, 'input', 3);
	delete(findobj(gcf, 'type', 'text'));
	subplot(221);
	title(['(a) Initial MFs on ', ...
		deblank(input_name(input_index(1),:)), ...
		', ', ...
		deblank(input_name(input_index(2),:)), ...
		', and ', ...
		deblank(input_name(input_index(3),:))]);
	subplot(222);
	title(['(b) Final MFs on ', deblank(input_name(input_index(1),:))]);
	subplot(223);
	title(['(c) Final MFs on ', deblank(input_name(input_index(2),:))]);
	subplot(224);
	title(['(d) Final MFs on ', deblank(input_name(input_index(3),:))]);
end
