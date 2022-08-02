% Get data for inverse control
with_chk_data = 0;
t = (0:100)';
u = 0.8*sin(2*pi*t/250)+0.2*sin(2*pi*t/50);
u = 2*rand(size(t))-1;
y = ones(length(t), 1);
y(1) = 0.9;
% find the output y(k)
for i = 1:length(t)-1;
	y(i+1) = plant(y(i), u(i));
end

blackbg;
subplot(211); plot(t, u, '-', t, u, 'go');
xlabel('Time'); ylabel('u(k)'); axis([-inf inf -inf inf]);
subplot(212); plot(t, y, '-', t, y, 'go');
xlabel('Time'); ylabel('y(k)'); axis([-inf inf -inf inf]);

% collect training data of the format: [y(k) y(k+1); u(k)]
% this is forward training data
col1 = y; col1(length(col1)) = [];
col2 = y; col2(1) = [];
col3 = u; col3(length(col3)) = [];
data = [col1 col2 col3];
data_n = size(data, 1);

% save training and checking data
if with_chk_data,
	tmp = randperm(data_n);
	trn_data = data(tmp(1:2:data_n), :);
	chk_data = data(tmp(2:2:data_n), :);
	save inv_trn.dat trn_data -ascii
	save inv_chk.dat chk_data -ascii
else
	trn_data = data;
	save inv_trn.dat trn_data -ascii
end

% plotting training data and checking data as a scatter plot
figure; blackbg;
subplot(2,2,1);
if with_chk_data,
	plot(trn_data(:,1), trn_data(:,2), 'o', chk_data(:,1), chk_data(:,2), '+');
else
	plot(trn_data(:,1), trn_data(:,2), 'o');
end
xlabel('y(k)'); ylabel('y(k+1)');
axis equal; axis square;

return

x = trn_data(:, 1);
y = trn_data(:, 2);
z = trn_data(:, 3);
point_n = 20;
xi = linspace(min(x), max(x), point_n);
yi = linspace(min(y), max(y), point_n);
[XI, YI] = meshgrid(xi,yi);
ZI = griddata(x,y,z,XI,YI);
figure; blackbg;
h1 = mesh(XI,YI,ZI);
set(h1, 'clipping', 'on');
hold on
h2 = plot3(x, y, z, 'yo');
set(h2, 'clipping', 'on');
h3 = plot3(chk_data(:,1), chk_data(:,2), chk_data(:,3), 'm+');
set(h3, 'clipping', 'on');
hold off
grid on
xlabel('X --> y(k)'); ylabel('Y --> y(k+1)'); zlabel('u(k)');
%view([-37.5-90 30]);
set(gca, 'box', 'on');
axis([min(x) max(x) min(y) max(y) min(z) max(z)]);
axis([-inf inf -inf inf -inf inf]);
