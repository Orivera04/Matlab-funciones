% Get data for inverse control
t = (0:100)';
u = 0.8*sin(2*pi*t/250)+0.2*sin(2*pi*t/50);
u = 2*rand(size(t))-1;
y = ones(length(t), 1);
y(1) = 0.9;
% find the output y(k)
for i = 1:length(t)-1;
	y(i+1) = plant(y(i), u(i));
end

genfig('Collecting data for inverse learning');
blackbg;
subplot(211); plot(t, u, '-', t, u, 'go');
xlabel('Time'); ylabel('u(k)'); axis([-inf inf -inf inf]);
subplot(212); plot(t, y, '-', t, y, 'go');
xlabel('Time'); ylabel('y(k)'); axis([-inf inf -inf inf]);
drawnow

% collect training data of the format: [y(k) y(k+1); u(k)]
% this is forward training data
col1 = y; col1(length(col1)) = [];
col2 = y; col2(1) = [];
col3 = u; col3(length(col3)) = [];
data = [col1 col2 col3];
trn_data = data;
x_data = trn_data(:, 1);
y_data = trn_data(:, 2);
z_data = trn_data(:, 3);

% plotting training data as a scatter plot
genfig('training data distribution');
blackbg;
subplot(2,2,1); plot(x_data, y_data, 'o');
xlabel('y(k)'); ylabel('y(k+1)'); title('Training Data');
axis equal; axis square;

subplot(2,2,2); plot3(x_data, y_data, z_data,'o');
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
xlabel('y(k)'); ylabel('y(k+1)'); title('Training Data');
drawnow

% generate initial FIS matrix
mf_n = 3;
epoch_n = 50;
ss = 0.1;
mf_type = 'gbellmf';
in_fismat = genfis1(trn_data, mf_n, mf_type);

% start training
[trn_out_fismat trn_error step_size] = ...
	anfis(trn_data, in_fismat, [epoch_n 0 ss], [1,1,1,1]);

% compute the result
z_hat = evalfis([x_data y_data], trn_out_fismat);

genfig('Error curve and step sizes');
blackbg;
subplot(2,2,1); plot(trn_error);
xlabel('Epochs'); ylabel('Root-Mean-Squared Error');
title('Error Curves');
subplot(2,2,2); plot(step_size);
xlabel('Epochs'); title('Step Sizes');
drawnow

genfig('Initial and final MFs');
blackbg;
% plot initial MF's on x and y
subplot(2,2,1);
[mfx, mfy] = plotmf(in_fismat, 'input', 1);
plot(mfx, mfy); title('(a) Initial MFs on y(k)'); axis([-inf inf 0 1.2]);
subplot(2,2,3);
[mfx, mfy] = plotmf(in_fismat, 'input', 2);
plot(mfx, mfy); title('(a) Initial MFs on y(k+1)'); axis([-inf inf 0 1.2]);

% plot final MF's on x and y
subplot(2,2,2);
[mfx, mfy] = plotmf(trn_out_fismat, 'input', 1);
plot(mfx, mfy); title('(a) Final MFs on y(k)'); axis([-inf inf 0 1.2]);
subplot(2,2,4);
input_index = 2;
[mfx, mfy] = plotmf(trn_out_fismat, 'input', 2);
plot(mfx, mfy); title('(a) Final MFs on y(k+1)'); axis([-inf inf 0 1.2]);
drawnow

% ANFIS surface plot
genfig('ANFIS surface');
blackbg;
point_n = 20;
x_tmp = linspace(min(x_data), max(x_data), point_n);
y_tmp = linspace(min(y_data), max(y_data), point_n);
[xx, yy] = meshgrid(x_tmp, y_tmp);
zz = evalfis([xx(:) yy(:)], trn_out_fismat);
subplot(2,2,1);
mesh(xx, yy, reshape(zz, point_n, point_n));
hold on; plot3(x_data, y_data, z_data, 'o'); hold off;
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
xlabel('y(k)'); ylabel('y(k+1)'); title('ANFIS Output');
view([240 60]);

% Verify the obtained controller
t = (0:300)';
u = 2*rand(size(t))-1;
desired_y = 0.6*sin(2*pi*t/250)+0.2*sin(2*pi*t/50);
%desired_y = 0.8*cos(2*pi*3*t/100);
y = ones(length(t), 1);
y(1) = 0.0;	% this is not important

for i = 1:length(t)-1;
	% Assuming we DO know desired_y(i+1);
	u(i) = evalfis([y(i) desired_y(i+1)], trn_out_fismat);
	y(i+1) = plant(y(i), u(i));
end

genfig('Application of inverse fuzzy controller');
blackbg;
subplot(2,2,1); plot(t, desired_y, ':', t, y, '-');
xlabel('Time'); ylabel('Actual and Desired y(k)');
legend('desired', 'actual');
subplot(2,2,2); plot(t, desired_y-y);
xlabel('Time'); ylabel('Error');
%subplot(2,2,3); plot(t, u);
%xlabel('Time'); ylabel('u(k)');

%surfview(trn_out_fismat);
