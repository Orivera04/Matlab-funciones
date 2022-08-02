houdata;
all_input_n = size(data,2)-1;
input_n = 4; % Up to input_n inputs are selected
anfis_n = 0;
for i = 1:input_n,
	anfis_n = anfis_n + (all_input_n-(i-1));
end
all_input_index = zeros(anfis_n, input_n);
all_trn_error = zeros(anfis_n, 1);
all_chk_error = zeros(anfis_n, 1);

% ======= Training options 
mf_n = 2;
mf_type = 'gbellmf';
epoch_n = 1;
ss = 0.1;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;
% ====== Train ANFIS with different input variables
input_index = [];
trn_error = realmax*ones(1, size(data,2)-1);
chk_error = realmax*ones(1, size(data,2)-1);
case = 1;
tic
for i=1:input_n,
  fprintf('\nSelecting input %d ...\n', i);
  for j=1:all_input_n,
    if isempty(input_index) | isempty(find(input_index==j)),
      current_input_index = [input_index, j];
      trn_data = data(1:trn_data_n, [current_input_index, size(data,2)]);
      chk_data = data(trn_data_n+1:size(data,1), [current_input_index, size(data,2)]);
      in_fismat = genfis1(trn_data, mf_n, mf_type);
      [trn_out_fismat t_err step_size chk_out_fismat c_err] = ...
	anfis(trn_data, in_fismat, ...
	[epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[0 0 0 0], chk_data);
      trn_error(j) = min(t_err);
      chk_error(j) = min(c_err);
      fprintf('case %d:', case);
      for k = 1:length(current_input_index),
        fprintf(' %s', deblank(input_name(current_input_index(k), :)));
      end
      fprintf(' --> trn=%.3f,', trn_error(j));
      fprintf(' chk=%.3f', chk_error(j));
      fprintf('\n');
      all_input_index(case,1:length(current_input_index)) = current_input_index;
      all_trn_error(case, 1) = trn_error(j);
      all_chk_error(case, 1) = chk_error(j);
      case = case+1;
    end
  end
  [a,b] = min(trn_error);
  input_index = [input_index, b];
  input_index = sort(input_index);
  fprintf('Currently selected inputs:');
  for p = 1:length(input_index),
    fprintf(' %s', deblank(input_name(input_index(p), :)));
  end
  fprintf('\n');
end
toc

figTitle = 'ANFIS: Input Selection';
figH = findobj(0, 'name', figTitle);
if isempty(figH),
	figH = figure('Name', figTitle, 'NumberTitle', 'off');
else
	set(0, 'currentfig', figH);
end

[a, b] = sort(all_trn_error);
all_trn_error = all_trn_error(flipud(b));
all_chk_error = all_chk_error(flipud(b));
all_input_index = all_input_index(flipud(b), :);

x = (1:anfis_n)';
subplot(211);
plot(x, all_trn_error, '-', x, all_chk_error, '-', ...
     x, all_trn_error, 'o', x, all_chk_error, '*');
tmp = x(:, ones(1, 3))';
X = tmp(:);
tmp = [zeros(anfis_n, 1) max(all_trn_error, all_chk_error) nan*ones(anfis_n, 1)]';
Y = tmp(:);
hold on; plot(X, Y, 'g'); hold off;
axis([1 anfis_n -inf inf]);
set(gca, 'xticklabels', []);

% ====== Add text of input variables
for k = 1:anfis_n,
	index = all_input_index(k, :);
	index(find(index==0))=[];
	leng = length(index);
	input_string = [];
	for l=1:leng,
		input_string = [input_string, ...
			deblank(input_name(index(l), :)), ' '];
	end
	text(x(k), 0, input_string);
end
h = findobj(gcf, 'type', 'text');
set(h, 'rot', 90, 'fontsize', 11, 'hori', 'right');
drawnow

% ====== Generate input_index for bjtrain.m
[a, b] = min(all_trn_error);
input_index = all_input_index(b, :);
input_index(find(input_index==0))=[];
input_index = sort(input_index);
title('Training (Circles) and Test (Asterisks) Errors');
ylabel('RMSE');
