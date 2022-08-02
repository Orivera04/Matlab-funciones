
% ====== Generate training data
data_n = 101;
x = linspace(-1, 1, data_n)';
y = 0.6*sin(pi*x) + 0.3*sin(3*pi*x) + 0.1*sin(5*pi*x);
trn_data = [x y];

% ====== Main loop
for mf_n = 2:5,
	% ====== ANFIS training
	initial_fismat = genfis1(trn_data, mf_n, 'gbellmf');
	final_fismat = anfis(trn_data, initial_fismat, 1);
	anfis_out = evalfis(trn_data, final_fismat);
	% ====== plot desired and anfis output
	subplot(4, 3, (mf_n-2)*3+1);
	plot(x, [y anfis_out]);
	% ====== plot MFs
	subplot(4, 3, (mf_n-2)*3+2);
	[junk, mf] = plotmf(final_fismat, 'input', 1, data_n);
	plot(x, mf);
	axis([-inf inf 0 1.2]);
	% ====== plot each rule's output
	subplot(4, 3, (mf_n-2)*3+3);
	max_mf = max(mf')'*ones(1, mf_n);
	index = find(mf ~= max_mf);
	cons_param = getfis(final_fismat, 'outmfparams');
	rule_output = [x ones(size(x))]*cons_param';
	rule_output(index) = NaN*index;
	plot(x, rule_output);
	axis([-inf inf -1 1]);
end
