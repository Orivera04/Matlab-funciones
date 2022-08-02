% This script requires the System Identification Toolbox from the MathWorks
% Roger Jang, Aug-10-96

load dryer2
z = [y2 u2];
z = dtrend(z);
ave = mean(y2);
trn_data_n = 300;
total_data_n = 1000;
ze = z(1:trn_data_n, :);
zv = z(trn_data_n+1:total_data_n, :);
T = 0.08;

V = arxstruc(ze, zv, struc(2,2,1:10));
nn = selstruc(V, 0);
nk = nn(3);	% select the best delay
% Run through all different models
%V = arxstruc(ze, zv, struc(1:10, 1:10, nk-1:nk+1));
tic
V = arxstruc(ze, zv, struc(1:10, 1:10, 1:10));
toc
% Find the best model
nn = selstruc(V, 0);
% Plot loss fcn w.r.t. models
% nn = selstruc(V);

%nn = [2 2 3];
% Time domain plot
th = arx(ze, nn);
th = sett(th, 0.08);
u = z(:, 2);
y = z(:, 1)+ave;
yp = idsim(u, th)+ave;

figure;
subplot(2,1,1); index = 1:trn_data_n;
plot(index, y(index), index, yp(index), '.');
rmse = norm(y(index)-yp(index))/sqrt(length(index));
title(['(a) Training Data (Solid Line) and ARX Prediction (Dots) with RMSE = ' num2str(rmse)]);
disp(['[na nb d] = ' num2str(nn)]);
xlabel('Time Index');

subplot(2,1,2); index = (trn_data_n+1):(trn_data_n+300);
plot(index, y(index), index, yp(index), '.');
rmse = norm(y(index)-yp(index))/sqrt(length(index));
title(['(b) Test Data (Solid Line) and ARX Prediction (Dots) with RMSE = ' num2str(rmse)]);
xlabel('Time Index');
