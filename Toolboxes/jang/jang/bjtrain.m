% This file should be run after select*.m
% input_index is defined after running bjpick?.m

if exist('input_index') ~= 1,
	fprintf('The variable "input_index" is not defined.\n');
	fprintf('Run "bjpick2" to find "input_index" first.\n');
	return;
end

mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 100;
ss = 0.01;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% collect training data
% data format:
% [y(t) y(t-1) y(t-2) y(t-3) y(t-4)
%  u(t-1) u(t-2) u(t-3) u(t-4) u(t-5) u(t-6)]
output = bj(:, 1);
input = bj(:, input_index+1); 
data = [input output];
trn_data = data(1:145, :);
chk_data = data(146:290, :);

% generate FIS matrix
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
if isempty(chk_data),
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[1,1,1,1]);
else
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[1,1,1,1], chk_data);
end

% compute the result

figTitle = 'ANFIS: Two-Input System';
figH = findobj(0, 'name', figTitle);
if isempty(figH),
	figH = figure(...
		'Name', figTitle, ...
		'NumberTitle', 'off');
else
	set(0, 'currentfig', figH);
end

blackbg;
subplot(2,2,1);
if isempty(chk_data),
	tmp = [trn_error];
else
	tmp = [trn_error chk_error];
end
[a, b] = min(chk_error);
plot(1:epoch_n, trn_error, '-', ...
     1:epoch_n, chk_error, ':', ...
     b, a, 'go');
xlabel('Epochs');
ylabel('RMSE');
title('(a) Error Curves');
legend('Training error', 'Checking error');

% plot of training data
subplot(2,2,2);
plot(trn_data(:,1), trn_data(:, 2), 'yo', ...
	chk_data(:,1), chk_data(:, 2), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(2), :)));
title('(b) Data Distribution');
legend('Trn. data', 'Chk. data');

%y_hat = evalfis(input, trn_out_fismat);
y_hat = evalfis(input, chk_out_fismat);
subplot(2,2,3);
plot(1:length(output), output, '-', ...
     1:length(output), y_hat, ':');
title('(c) ANFIS Prediction');
xlabel('Time'); ylabel('Time Series');
legend('Desired curve', 'ANFIS prediction');

subplot(2,2,4);
point_n = 50;
x = linspace(min(input(:,1)), max(input(:,1)), point_n);
y = linspace(min(input(:,2)), max(input(:,2)), point_n);
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

figure;
blackbg;
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
