function trn_2in(mf_n, epoch_n)
% This script requires the Fuzzy Logic Toolbox from the MathWorks.

if nargin < 2, epoch_n = 100; end;
if nargin < 1, mf_n = 4; end;

% ====== collect training data
point_n = 11;
x = linspace(-10, 10, point_n);
y = linspace(-10, 10, point_n);
[xx, yy] = meshgrid(x, y);

tmp1 = sin(xx)./(xx);
index = find(isnan(tmp1)==1);
tmp1(index) = ones(size(index));

tmp2 = sin(yy)./(yy);
index = find(isnan(tmp2)==1);
tmp2(index) = ones(size(index));

zz = tmp1.*tmp2;
trn_data = [xx(:) yy(:) zz(:)];

% ====== training options
ss = 0.1;
ss_dec_rate = 0.9;
ss_inc_rate = 1.1;
mf_type = 'gbellmf';

% ====== generate the initial FIS 
in_fismat = genfis1(trn_data, mf_n, mf_type);

% ====== start training
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
		[1,1,1,1]);
% ====== compute ANFIS output 
z_hat = evalfis([xx(:) yy(:)], trn_out_fismat);

% ====== plot of training data
genfig('training data');
blackbg;
subplot(221);
mesh(xx, yy, zz);
limit = [min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:)) ...
	min(zz(:)) max(zz(:))];
axis(limit); set(gca, 'box', 'on');
xlabel('X'); ylabel('Y'); title('Training data');

zz_hat = evalfis([xx(:) yy(:)], trn_out_fismat);
subplot(222);
mesh(xx, yy, reshape(zz_hat, point_n, point_n));
axis(limit); set(gca, 'box', 'on');
xlabel('X'); ylabel('Y'); title('ANFIS Output');

subplot(223)
plot(1:epoch_n, trn_error);
xlabel('epoch number'); ylabel('root mean squared error');
title('error curve');

subplot(224)
plot(1:epoch_n, step_size);
xlabel('epoch number'); ylabel('step size');
title('step size curve');

% ====== plot MFs
figH = genfig('MFs for SINC function training');
blackbg;
% plot initial MFs on x and y
subplot(221); plotmf(in_fismat, 'input', 1);
subplot(222); plotmf(in_fismat, 'input', 2);
subplot(223); plotmf(trn_out_fismat, 'input', 1);
subplot(224); plotmf(trn_out_fismat, 'input', 2);

delete(findobj(figH, 'type', 'text'));
subplot(221); title('Initial MFs on X');
subplot(222); title('Initial MFs on Y');
subplot(223); title('Final MFs on X');
subplot(224); title('Final MFs on Y');

