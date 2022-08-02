% collect training data
% data format:
% [y(k) y(k-1) y(k-2) y(k-3) y(k-4)
%  u(k-1) u(k-2) u(k-3) u(k-4) u(k-5) u(k-6)]
load bj.dat
output = bj(:, 1);
input = bj(:, 2:11); 
data = [input output];
%input_name = str2mat('y(k-1)', 'y(k-2)', 'y(k-3)', 'y(k-4)', ...
%	'u(k-1)', 'u(k-2)', 'u(k-3)', 'u(k-4)', 'u(k-5)', 'u(k-6)');
input_name = str2mat('y(k)', 'y(k-1)', 'y(k-2)', 'y(k-3)', ...
	'u(k)', 'u(k-1)', 'u(k-2)', 'u(k-3)', 'u(k-4)', 'u(k-5)');

group1 = [1 2 3 4];	% y(k-1), y(k-2), y(k-3), y(k-4)
group2 = [1 2 3 4];	% y(k-1), y(k-2), y(k-3), y(k-4)
group3 = [5 6 7 8 9 10];	% u(k-1) through y(k-6)

anfis_n = 6*length(group3);
index = zeros(anfis_n, 3);
trn_error = zeros(anfis_n, 1);
chk_error = zeros(anfis_n, 1);
% ======= Training options 
mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 1;
ss = 0.1;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;
% ====== Train ANFIS with different input variables
fprintf('\nTrain %d ANFIS models, each with 3 inputs selected from 10 candidates...\n\n',...
	anfis_n);
case = 1;
tic
for i=1:length(group1),
  for j=i+1:length(group2),
    for k=1:length(group3),
	in1 = deblank(input_name(group1(i), :));
	in2 = deblank(input_name(group2(j), :));
	in3 = deblank(input_name(group3(k), :));
	fprintf('case = %d: %s %s %s\n', case, in1, in2, in3);
	index(case, :) = [group1(i) group2(j) group3(k)];
	trn_data = data(1:145, [group1(i) group2(j) group3(k) 11]);
	chk_data = data(146:290, [group1(i) group2(j) group3(k) 11]);
	in_fismat = genfis1(trn_data, mf_n, mf_type);
	[trn_out_fismat t_err step_size chk_out_fismat c_err] = ...
		anfis(trn_data, in_fismat, ...
		[epoch_n nan ss ss_dec_rate ss_inc_rate], ...
		[0 0 0 0], chk_data);
	trn_error(case) = min(t_err);
	chk_error(case) = min(c_err);
	case = case+1;
    end
  end
end
toc

% ====== Reordering according to training error
[a b] = sort(trn_error);
trn_error = trn_error(b);
chk_error = chk_error(b);
index = index(b, :);
% ====== Display training and checking errors
figTitle = 'ANFIS: Input Selection';
figH = findobj(0, 'name', figTitle);
if isempty(figH),
	figH = figure(...
		'Name', figTitle, ...
		'NumberTitle', 'off');
else
	set(0, 'currentfig', figH);
end

x = (1:anfis_n)';
subplot(211);
plot(x, trn_error, '-', x, trn_error, 'o', ...
	x, chk_error, '-', x, chk_error, 'o');
tmp = x(:, ones(1, 3))';
X = tmp(:);
tmp = [zeros(anfis_n, 1) max(trn_error, chk_error) nan*ones(anfis_n, 1)]';
Y = tmp(:);
hold on; plot(X, Y, 'g-'); hold off;
axis([1 anfis_n -inf inf]);
set(gca, 'xticklabels', []);
ylabel('RMSE');

% ====== Add text of input variables
for k = 1:anfis_n,
	text(x(k), 0, ...
	[input_name(index(k,1), :) ' ' ...
	 input_name(index(k,2), :) ' ' ...
	 input_name(index(k,3), :)]);
end
h = findobj(gcf, 'type', 'text');
set(h, 'rot', 90, 'fontsize', 11, 'hori', 'right');
drawnow

% ====== Generate input_index for bjtrain.m
[a b] = min(trn_error);
input_index = [index(b,1) index(b,2) index(b,3)];
title('Training (Solid Line) and Test (Dashed Line) Errors');
