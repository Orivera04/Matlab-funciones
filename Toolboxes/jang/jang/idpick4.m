% collect training data
% data format:
% [y(t) y(t-1) y(t-2) y(t-3) y(t-4)
%  u(t-1) u(t-2) u(t-3) u(t-4) u(t-5) u(t-6)]
load dryer2
data_n = length(y2);
output = y2;
input = [[0; y2(1:data_n-1)] ...
	 [0; 0; y2(1:data_n-2)] ...
	 [0; 0; 0; y2(1:data_n-3)] ...
	 [0; 0; 0; 0; y2(1:data_n-4)] ...
	 [0; u2(1:data_n-1)] ...
	 [0; 0; u2(1:data_n-2)] ...
	 [0; 0; 0; u2(1:data_n-3)] ...
	 [0; 0; 0; 0; u2(1:data_n-4)] ...
	 [0; 0; 0; 0; 0; u2(1:data_n-5)] ...
	 [0; 0; 0; 0; 0; 0; u2(1:data_n-6)]];
data = [input output];
data(1:6, :) = [];
input_name = str2mat('y(t-1)', 'y(t-2)', 'y(t-3)', 'y(t-4)', ...
	'u(t-1)', 'u(t-2)', 'u(t-3)', 'u(t-4)', 'u(t-5)', 'u(t-6)');

group1 = [1 2 3 4];	% y(t-1), y(t-2), y(t-3), y(t-4)
group2 = [1 2 3 4];	% y(t-1), y(t-2), y(t-3), y(t-4)
group3 = [5 6 7 8 9 10];	% u(t-1) through y(t-6)
group4 = [5 6 7 8 9 10];	% u(t-1) through y(t-6)

anfis_n = 6*15;
index = zeros(anfis_n, 4);
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
fprintf('Train ANFIS with %d combinations of input variables...\n\n',...
	anfis_n);
case = 1;
for i=1:length(group1),
  for j=i+1:length(group2),
    for k=1:length(group3),
      for l=k+1:length(group4),
	in1 = deblank(input_name(group1(i), :));
	in2 = deblank(input_name(group2(j), :));
	in3 = deblank(input_name(group3(k), :));
	in4 = deblank(input_name(group4(l), :));
	fprintf('case = %d: %s %s %s %s\n', case, in1, in2, in3, in4);
	index(case, :) = [group1(i) group2(j) group3(k) group4(l)];
	trn_data = data(1:300, ...
		[group1(i) group2(j) group3(k) group4(l) 11]);
	chk_data = data(301:size(data,1), ...
		[group1(i) group2(j) group3(k) group4(l) 11]);
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
end

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
	x, chk_error, ':', x, chk_error, 'o');
tmp = x(:, ones(1, 3))';
X = tmp(:);
tmp = [zeros(anfis_n, 1) max(trn_error, chk_error) nan*ones(anfis_n, 1)]';
Y = tmp(:);
hold on; plot(X, Y, 'g:'); hold off;
axis([1 anfis_n -inf inf]);
set(gca, 'xticklabels', []);
ylabel('RMSE');

% ====== Add text of input variables
for k = 1:anfis_n,
	text(x(k), 0, ...
	[input_name(index(k,1), :) ' ' ...
	 input_name(index(k,2), :) ' ' ...
	 input_name(index(k,3), :) ' ' ...
	 input_name(index(k,4), :)]);
end
h = findobj(0, 'type', 'text');
set(h, 'rot', 90, 'fontsize', 11, 'hori', 'right');
drawnow

% ====== Generate input_index for bjtrain.m
[a b] = min(trn_error);
input_index = [index(b,1) index(b,2) index(b,3) index(b,4)];
title('Training (Solid Line) and Test (Dotted Line) Errors');
