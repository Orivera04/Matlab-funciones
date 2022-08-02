function trn_3in(mf_n, epoch_n)
% This script requires the Fuzzy Logic Toolbox from the MathWorks.

if nargin < 2, epoch_n = 100; end;
if nargin < 1, mf_n = 2; end;

% ====== collect training data
point_n = 6;
x = linspace(1, 6, point_n);
y = linspace(1, 6, point_n);
z = linspace(1, 6, point_n);
trn_data = zeros(length(x)*length(y)*length(z), 4);
count = 1;
for i = x,
	for j = y;
		for k = z;
			out = (1+i^0.5+j^(-1)+k^(-1.5))^2;
			trn_data(count, :) = [i j k out];
			count = count + 1; 
		end
	end
end

% ====== collect checking data
point_n = 5;
x = linspace(1.5, 5.5, point_n);
y = linspace(1.5, 5.5, point_n);
z = linspace(1.5, 5.5, point_n);
chk_data = zeros(length(x)*length(y)*length(z), 4);
count = 1;
for i = x,
	for j = y;
		for k = z;
			out = (1+i^0.5+j^(-1)+k^(-1.5))^2;
			chk_data(count, :) = [i j k out];
			count = count + 1; 
		end
	end
end

% ====== training options
ss = 0.1;
ss_dec_rate = 0.9;
ss_inc_rate = 1.1;
mf_type = 'gbellmf';
in_fismat = genfis1(trn_data, mf_n, mf_type);

% ====== start training
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, ...
	[epoch_n nan ss ss_dec_rate ss_inc_rate], [1,1,1,1], chk_data);
% compute the result

% ====== plot MFs
figH = genfig('MFs for SINC function training');
blackbg;
% plot initial MFs on x and y
subplot(221); plotmf(in_fismat, 'input', 1);
subplot(222); plotmf(trn_out_fismat, 'input', 1);
subplot(223); plotmf(trn_out_fismat, 'input', 2);
subplot(224); plotmf(trn_out_fismat, 'input', 3);

delete(findobj(figH, 'type', 'text'));
subplot(221); title('Initial MFs on X, Y and Z');
subplot(222); title('Initial MFs on Y');
subplot(223); title('Final MFs on X');
subplot(224); title('Final MFs on Y');

% ====== plot error curve and step size
figH = genfig('Error curves and step sizes curve');
blackbg;
subplot(221)
plot(1:epoch_n, [trn_error chk_error]);
legend('training error', 'checking error');
xlabel('epoch number'); ylabel('root mean squared error');
title('error curves');

subplot(222)
plot(1:epoch_n, step_size);
xlabel('epoch number'); ylabel('step size');
title('step size curve');

