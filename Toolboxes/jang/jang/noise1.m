%function out_fismat = noise(mf_type, mf_n, dataset)

%if nargin < 3, dataset = 1; end
%if nargin < 2, mf_n = 2; end
%if nargin < 1, mf_type = 'gbellmf'; end

close all;

dataset = 1;
mf_n = 2;
mf_type = 'gbellmf';

sample_n = 1001;
freq = sample_n/5;
t = linspace(0, 5, sample_n)';	% time
x = sin(2*t);			% info signal
x = zeros(size(t));		% info signal
x = randn(size(t));		% info signal
x = sin(2*40./(t+0.01));	% info signal

n = (sin(2*pi*20*t)+sin(2*pi*40*t)+sin(2*pi*60*t)+sin(2*pi*80*t))/4 ...
	+ randn(size(t));
n = randn(size(t));		% noise source
load noise1.mat			% load n(k) from file

n0 = n;
n1 = [0; n0(1:length(n0)-1)];	% delay noise by one time unit
n2 = [0; n1(1:length(n1)-1)];	% delay noise by two time unit
n3 = [0; n2(1:length(n2)-1)];	% delay noise by three time unit
n4 = [0; n3(1:length(n3)-1)];	% delay noise by four time unit
input_matrix = [n0 n1 n2 n3 n4];

if dataset == 1,
	input_n = 2;
	d = 4*sin(n0).*n1./(1 + n1.^2);
else
	input_n = 3;
	d = 8*sin(n0).*n1.*n2./(1 + n1.^2 + n2.^2);% distorted noise
end
y = x + d;					% measured signal

% collect training data
all_data = [input_matrix(:, 1:input_n) y];% [x(k) x(k-1) x(k-2) ; y(k)]
all_data(1:input_n-1, :) = [];	% delete several initial data points
y(1:input_n-1, :) = [];		% delete several initial data points
x(1:input_n-1, :) = [];		% delete several initial data points
n(1:input_n-1, :) = [];		% delete several initial data points
d(1:input_n-1, :) = [];		% delete several initial data points
t(1:input_n-1, :) = [];		% delete several initial data points

epoch_n = 20;
ss = 0.1;
trn_data_n = 500;
trn_data = all_data(1:trn_data_n, :);
in_fismat = genfis1(trn_data, mf_n);
[out_fismat, error, stepsize] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss], [1,1,1,1]);
d_hat = evalfis(all_data, out_fismat);

x_hat = y - d_hat;
diff = x - x_hat;

tmp = [x n d y d_hat x_hat diff];
axis_2D = [min(t*freq) max(t*freq) min(tmp(:)) max(tmp(:))];

% ====== plot original signals 
blackbg;
subplot(2,2,1); plot(t*freq, x);
title('(a) Information Signal'); ylabel('x(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,2); plot(t*freq, n);
title('(b) Noise Source Signal'); ylabel('n(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,3); plot(t*freq, d)
title('(c) Distorted Noise Signal'); ylabel('d(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,4); plot(t*freq, y);
title('(d) Measured Signal'); ylabel('y(k)'); xlabel('k');
axis(axis_2D);
%print -deps info1

% ====== plot spectra 
point_n = 256;	% for Fourier transform
f = freq/point_n*(0:point_n/2-1);
X = fft(x, point_n);
Pxx = X.*conj(X)/point_n;
Y = fft(y, point_n);
Pyy = Y.*conj(Y)/point_n;
N = fft(n, point_n);
Pnn = N.*conj(N)/point_n;
D = fft(d, point_n);
Pdd = D.*conj(D)/point_n;

tmp = [Pxx; Pyy; Pnn; Pdd];
spectrum_axis = [min(f) max(f) min(tmp) max(tmp)];

figure;
blackbg;
subplot(2,2,1); plot(f, Pxx(1:point_n/2));
axis(spectrum_axis);
title('(a) Power Spectral Density of x(k)'); xlabel('Frequency (Hz)');
subplot(2,2,2); plot(f, Pyy(1:point_n/2));
axis(spectrum_axis);
title('(b) Power Spectral Density of y(k)'); xlabel('Frequency (Hz)');
subplot(2,2,3); plot(f, Pnn(1:point_n/2));
axis(spectrum_axis);
title('(c) Power Spectral Density of n(k)'); xlabel('Frequency (Hz)');
subplot(2,2,4); plot(f, Pdd(1:point_n/2));
axis(spectrum_axis);
title('(d) Power Spectral Density of d(k)'); xlabel('Frequency (Hz)');
%print -deps spectra1

% ====== plot ANFIS surface
figure
blackbg;
if input_n == 2,	% Do this only when it's 2-input ANFIS
cartesian = 1;
if cartesian,
	% The following are plots on square regions
	[xx, yy, zz] = gensurf(out_fismat, [1 2], 1, 30);
else
	% The following are plots on circular regions
	max_r = max(sqrt(trn_data(:,1).^2 + trn_data(:,2).^2));
	r = linspace(0, max_r, 20);
	th = linspace(0, 2*pi, 40);
	[rr, thth] = meshgrid(r, th);
	xx = rr.*cos(thth);
	yy = rr.*sin(thth);
	zz = zeros(size(xx));
	tmp = evalfis([xx(:) yy(:)], out_fismat);
	zz(:) = tmp;
end

zz1 = 4*sin(xx).*yy./(1 + yy.^2);
axis_3D = [min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:)) ...
	min([zz(:);zz1(:)]) max([zz(:);zz1(:)])];
subplot(2,2,1); mesh(xx, yy, zz1); set(gca, 'box', 'on');
title('(a) Passage Characteristics');
xlabel('n(k)'); ylabel('n(k-1)'); zlabel('d(k-1)');
axis(axis_3D);
subplot(2,2,2); mesh(xx, yy, zz); set(gca, 'box', 'on');
title('(b) ANFIS Function');
xlabel('n(k)'); ylabel('n(k-1)'); zlabel('d(k-1)');
axis(axis_3D);
subplot(2,2,3);
plot(trn_data(:,1), trn_data(:,2), 'o');
axis([min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:))]);
title('(c) Training Data Distribution');
xlabel('n(k)'); ylabel('n(k-1)');
axis square;
end
subplot(2,2,4);
min_error = norm(x(1:trn_data_n))/sqrt(trn_data_n);
plot(1:epoch_n, error);
hold on
%plot(1:epoch_n, error, 'o', [1,epoch_n], [min_error,min_error], '--');
plot(1:epoch_n, error, 'o');
hold off
title('(c) Training Error');
xlabel('Epochs'); ylabel('RMSE');
axis([-inf inf -inf inf]);
%print -deps nsesurf1

% ====== plot estimated signals 
figure;
blackbg;
subplot(2,2,1); plot(t*freq, d_hat)
title('(a) Estimated Distorted Noise');ylabel('d_hat(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,2); plot(t*freq, x_hat)
title('(b) Estimated Info Signal');ylabel('x_hat(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,3); plot(t*freq, diff);
title('(c) Estimation Error'); ylabel('x(k)-x_hat(k)'); xlabel('k');
axis(axis_2D);
subplot(2,2,4); plot(t*freq, x);
title('(d) Original Information Signal'); ylabel('x(k)'); xlabel('k');
axis(axis_2D);
%print -deps estinfo1

% plot MFs
figure;
blackbg;

if input_n == 2,
subplot(2,2,1); plotmf(in_fismat, 'input', 1); axis([-inf inf 0 1.2]);
subplot(2,2,2); plotmf(in_fismat, 'input', 2); axis([-inf inf 0 1.2]);
subplot(2,2,3); plotmf(out_fismat, 'input', 1); axis([-inf inf 0 1.2]);
subplot(2,2,4); plotmf(out_fismat, 'input', 2); axis([-inf inf 0 1.2]);

delete(findobj(gcf, 'type', 'text'));
subplot(2,2,1);
xlabel('n(k)'); ylabel('Membership grade'); title('Initial MFs for n(k)');
subplot(2,2,2);
xlabel('n(k-1)'); ylabel('Membership grade'); title('Initial MFs for n(k-1)');
subplot(2,2,3);
xlabel('n(k)'); ylabel('Membership grade'); title('Final MFs for n(k)');
subplot(2,2,4);
xlabel('n(k-1)'); ylabel('Membership grade'); title('Final MFs for n(k-1)');
%print -deps noisemf1
end

if input_n == 3,
subplot(2,3,1); plotmf(in_fismat, 'input', 1); axis([-inf inf 0 1.2]);
subplot(2,3,2); plotmf(in_fismat, 'input', 2); axis([-inf inf 0 1.2]);
subplot(2,3,3); plotmf(in_fismat, 'input', 3); axis([-inf inf 0 1.2]);
subplot(2,3,4); plotmf(out_fismat, 'input', 1); axis([-inf inf 0 1.2]);
subplot(2,3,5); plotmf(out_fismat, 'input', 2); axis([-inf inf 0 1.2]);
subplot(2,3,6); plotmf(out_fismat, 'input', 3); axis([-inf inf 0 1.2]);

delete(findobj(gcf, 'type', 'text'));
subplot(2,3,1);
xlabel('n(k)'); ylabel('Membership grade'); title('Initial MFs for n(k)');
subplot(2,3,2);
xlabel('n(k-1)'); ylabel('Membership grade'); title('Initial MFs for n(k-1)');
subplot(2,3,3);
xlabel('n(k-2)'); ylabel('Membership grade'); title('Initial MFs for n(k-2)');
subplot(2,3,4);
xlabel('n(k)'); ylabel('Membership grade'); title('Final MFs for n(k)');
subplot(2,3,5);
xlabel('n(k-1)'); ylabel('Membership grade'); title('Final MFs for n(k-1)');
subplot(2,3,6);
xlabel('n(k-1)'); ylabel('Membership grade'); title('Final MFs for n(k-2)');
%print -deps mf2
end
