% ====== collect training data
point_n = 21;
[xx, yy, zz] = peaks(point_n);
data = [xx(:) yy(:) zz(:)];
data_n = size(data, 1);
trn_data = data(1:2:data_n, :);
chk_data = data(2:2:data_n, :);

% ====== generate initial FIS matrix
mf_n = 4;
mf_type = 'gbellmf';
in_fismat = genfis1(trn_data, mf_n, mf_type);

% ====== training options
epoch_n = 100;
error_goal = 0;
ss = 0.1;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% ====== start ANFIS training
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, ...
	[epoch_n error_goal ss ss_dec_rate ss_inc_rate], ...
	nan, chk_data);

% ====== save trained FIS to a file
writefis(chk_out_fismat, 'peaks.fis');

% ====== plot initial and final MFs on x and y
figure;
subplot(2,2,1);
plotmf(in_fismat, 'input', 1);
%delete(findobj(gca, 'type', 'text'));
title('Initial MFs on X');
subplot(2,2,2);
plotmf(in_fismat, 'input', 2);
title('Initial MFs on Y');
subplot(2,2,3);
plotmf(trn_out_fismat, 'input', 1);
title('Final MFs on X');
subplot(2,2,4);
plotmf(trn_out_fismat, 'input', 2);
title('Final MFs on Y');

% ====== plot of data sets and ANFIS output
figure;
subplot(2,2,1);
mesh(xx, yy, zz);
limit = [min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:)) min(zz(:)) max(zz(:))];
axis(limit);
set(gca, 'box', 'on');
title('Training and Checking Data');
xlabel('X'); ylabel('Y');

zz_hat = evalfis([xx(:) yy(:)], trn_out_fismat);
subplot(2,2,2);
mesh(xx, yy, reshape(zz_hat, point_n, point_n));
axis(limit);
set(gca, 'box', 'on');
xlabel('X'); ylabel('Y'); title('ANFIS Output');

% ====== plot error curves
subplot(2,2,3);
plot([trn_error chk_error]);
title('Error Curves');
legend('trn_error', 'chk_error');

% ====== plot error curves
subplot(2,2,4);
plot(step_size);
title('Step Sizes');
