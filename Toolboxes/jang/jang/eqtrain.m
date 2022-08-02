function eqtrain(mf_n, mf_type)

if nargin < 2, mf_type = 'gbellmf'; end
if nargin < 1, mf_n = 2; end

%mf_n = 4;
%mf_type = 'gbellmf';

% training options
epoch_n = 1;
ss = 0.1;
ss_dec_rate = 0.5;
ss_inc_rate = 1.5;

% load training data
load equtrain.dat
trn_data = equtrain;
chk_data = [];
point_n = 51;
x = linspace(min(trn_data(:,1)), max(trn_data(:,1)), point_n);
y = linspace(min(trn_data(:,2)), max(trn_data(:,2)), point_n);
[xx, yy] = meshgrid(x, y);

% generate FIS matrix
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
if isempty(chk_data),
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[1,1,1,1]);
else
[trn_out_fismat trn_error step_size chk_out_fismat chk_error] = ...
	anfis(trn_data, in_fismat, [epoch_n nan ss ss_dec_rate ss_inc_rate], ...
	[1,1,1,1], chk_data);
end

% compute the result
z_hat = evalfis([xx(:) yy(:)], trn_out_fismat);

figTitle = 'ANFIS for Channel Equalization';
figH = findobj(0, 'name', figTitle);
if isempty(figH),
	screen_size = get(0, 'ScreenSize');
	h = screen_size(4)*0.8;
	w = h/2/0.75;
	figH = figure(...
		'Name', figTitle, ...
		'NumberTitle', 'off', ...
		'Position', [10 10 w h]);
	blackbg;
else
	set(0, 'currentFigure', figH);
end

subplot(421);
if isempty(chk_data),
	tmp = [trn_error];
else
	tmp = [trn_error chk_error];
end
plot(tmp);
title('Error Curves');
if epoch_n > 1,
	axis([0 epoch_n min(tmp(:)) max(tmp(:))]);
end

subplot(422);
plot(step_size);
title('Step Sizes');
axis([0 epoch_n min(step_size)-ss max(step_size)+ss]);

% plot MFs on x and y
subplot(423);
plotmf(in_fismat, 'input', 1);
delete(findobj(gca, 'type', 'text'));
title('Initial MFs on X');
subplot(424);
plotmf(in_fismat, 'input', 2);
delete(findobj(gca, 'type', 'text'));
title('Initial MFs on Y');
subplot(425);
plotmf(trn_out_fismat, 'input', 1);
delete(findobj(gca, 'type', 'text'));
title('Final MFs on X');
subplot(426);
plotmf(trn_out_fismat, 'input', 2);
delete(findobj(gca, 'type', 'text'));
title('Final MFs on Y');

% plot of training data
subplot(427);
index1 = find(trn_data(:,3) == -1);
index2 = find(trn_data(:,3) == 1);
plot3(...
	trn_data(index1,1), trn_data(index1,2), trn_data(index1,3), 'r.',...
	trn_data(index2,1), trn_data(index2,2), trn_data(index2,3), 'y.');
limit = [min(xx(:)) max(xx(:)) min(yy(:)) max(yy(:)) -inf inf];
axis(limit);
set(gca, 'box', 'on');
if isempty(chk_data),
	title('Training data');
else
	title('Training and Checking Data');
end
xlabel('X'); ylabel('Y');

z = evalfis([xx(:) yy(:)], trn_out_fismat);
zz = reshape(z, point_n, point_n);
uu = (zz>=0)-(zz<0);
subplot(428);
surf(xx, yy, zz);
axis(limit);
set(gca, 'box', 'on');
xlabel('X'); ylabel('Y'); title('ANFIS Output');

figure; 
blackbg;
subplot(2,2,1);
new_zz = zz;
index1 = find(zz >= 1);
new_zz(index1) = ones(size(index1));
index2 = find(zz <= -1);
new_zz(index2) = -ones(size(index2));
surf(xx, yy, new_zz);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
%frot3d on
title_str = ['ANFIS Surface: ' int2str(mf_n*mf_n) ' Rules'];
xlabel('x(t)'); ylabel('x(t-1)'); title(title_str);

subplot(2,2,2);
surf(xx, yy, new_zz);
hold on;
h = mesh(xx, yy, zeros(size(xx)));
% make the cutting surface transparent
%set(h, 'face', 'none');
hidden off
[a, contourH] = contour3(xx, yy, uu, [-realmax 0 realmax], 'y');
set(contourH, 'linewidth', 3);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
%frot3d on
xlabel('x(t)'); ylabel('x(t-1)'); title('Threshold = 0');

subplot(2,2,3);
surf(xx, yy, uu);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
%frot3d on
xlabel('x(t)'); ylabel('x(t-1)'); title('Decision Surface after Thresholding');

subplot(2,2,4);
pcolor(xx, yy, uu);
%cmd = ['save equ' int2str(mf_n) ' xx yy uu'];
%eval(cmd);
axis square; colormap(cool);
shading interp
xlabel('x(t)'); ylabel('x(t-1)'); title('Decision Boundary');

hold on
% plotting boundary as a contour
[a lineH] = contour(xx, yy, uu, [-realmax 0 realmax], 'y');
set(lineH, 'linewidth', 3, 'linestyle', '-'); 
hold off

% plot decision boundaries with various thresholds
%figure;
%for i = 1:9,
%	subplot(3,3,i);
%	pcolor(xx, yy, zz_new>i/10);
%	axis square; colormap(cool);
%	shading interp
%end
