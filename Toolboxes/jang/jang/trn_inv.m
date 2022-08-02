%with_chk_data = 0;	% this is defined in getdata.m
mf_n = 3;
epoch_n = 30;
ss = 0.1;
mf_type = 'gbellmf';
point_n = 15;

% get training data
load inv_trn.dat
trn_data = inv_trn;
xx = trn_data(:, 1);
yy = trn_data(:, 2);
zz = trn_data(:, 3);

% generate FIS matrix
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n 0 ss]);

% compute the result
z_hat = evalfis([xx(:) yy(:)], trn_out_fismat);

figH = figure;
pos = get(figH, 'pos');
pos(4) = 2*pos(4);
set(figH, 'pos', pos);

subplot(421);
tmp = [trn_error];
plot(tmp);
title('Error Curves');
axis([0 epoch_n min(tmp(:)) max(tmp(:))]);

subplot(422);
plot(step_size);
title('Step Sizes');
axis([0 epoch_n min(step_size)-ss max(step_size)+ss]);

% plot initial MF's on x and y
subplot(423);
[x, y] = plotmf(in_fismat, 'input', 1);
plot(x, y); title('Initial MF''s on X'); axis([-inf inf 0 1.2]);
subplot(425);
[x, y] = plotmf(in_fismat, 'input', 2);
plot(x, y); title('Initial MF''s on Y'); axis([-inf inf 0 1.2]);
title('Final MF''s on Y');

% plot final MF's on x and y
subplot(424);
[x, y] = plotmf(trn_out_fismat, 'input', 1);
plot(x, y); title('Final MF''s on X'); axis([-inf inf 0 1.2]);
subplot(426);
input_index = 2;
[x, y] = plotmf(trn_out_fismat, 'input', 2);
plot(x, y); title('Final MF''s on Y'); axis([-inf inf 0 1.2]);

% plot of training data
subplot(427);
plot3(xx, yy, zz,'o');
limit = [min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:)) min(zz(:)) max(zz(:))];
axis(limit);
set(gca, 'box', 'on');
title('Training data');
xlabel('X');
ylabel('Y');

point_n = 20;
xi = linspace(min(xx), max(xx), point_n);
yi = linspace(min(yy), max(yy), point_n);
[XX, YY] = meshgrid(xi, yi);
ZZ = evalfis([XX(:) YY(:)], trn_out_fismat);

subplot(428);
mesh(XX, YY, reshape(ZZ, point_n, point_n));
hold on;
plot3(xx, yy, zz,'o');
hold off;
axis(limit);
set(gca, 'box', 'on');
title('ANFIS output');
xlabel('X');
ylabel('Y');
