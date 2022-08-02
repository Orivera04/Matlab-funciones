houdata;
all_in_n = size(data, 2)-1;
in_n = 1;

anfis_n = prod(1:all_in_n)/(prod(1:in_n)*prod(1:(all_in_n-in_n)));
index = zeros(anfis_n, in_n);
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
fprintf('\nTrain %d ANFIS models, each with %d inputs selected from %d candidates...\n\n',...
	anfis_n, in_n, all_in_n);
case = 1;
tic
for i=1:all_in_n,
	in1 = deblank(input_name(i, :));
	fprintf('case = %d: %s\n', case, in1);
	index(case, :) = [i];
	trn_data = data(1:trn_data_n, [i all_in_n+1]);
	chk_data = data(trn_data_n+1:size(data,1), [i all_in_n+1]);
	in_fismat = genfis1(trn_data, mf_n, mf_type);
	[trn_out_fismat t_err step_size chk_out_fismat c_err] = ...
		anfis(trn_data, in_fismat, ...
		[epoch_n nan ss ss_dec_rate ss_inc_rate], ...
		[0 0 0 0], chk_data);
	trn_error(case) = min(t_err);
	chk_error(case) = min(c_err);
	case = case+1;
end
toc

% ====== Reordering according to training error
[a b] = sort(trn_error);
b = flipud(b);		% List according to decreasing trn error
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
plot(x, trn_error, '-', x, chk_error, '-', ...
     x, trn_error, 'o', x, chk_error, '*');
tmp = x(:, ones(1, 3))';
X = tmp(:);
tmp = [zeros(anfis_n, 1) max(trn_error, chk_error) nan*ones(anfis_n, 1)]';
Y = tmp(:);
hold on; plot(X, Y, 'g'); hold off;
axis([1 anfis_n -inf inf]);
set(gca, 'xticklabels', []);

% ====== Add text of input variables
for k = 1:anfis_n,
	text(x(k), 0, ...
	 deblank(input_name(index(k,1), :)));
end
h = findobj(gcf, 'type', 'text');
set(h, 'rot', 90, 'fontsize', 12, 'hori', 'right');
drawnow

% ====== Generate input_index for bjtrain.m
[a b] = min(trn_error);
input_index = index(b,:);
title('Training (Circles) and Test (Asterisks) Errors');
ylabel('RMSE');
