trn_data = [0 0 0;
	0 1 1;
	1 0 1;
	1 1 0];

x = trn_data(:, 1);
y = trn_data(:, 2);
out = trn_data(:, 3);
index1 = find(out == 0);
index2 = find(out == 1);

blackbg;
subplot(2,2,1);
h = plot(x(index1), y(index1), 'o', x(index2), y(index2), 'x');
set(h, 'markersize', 10, 'linewidth', 3);
xlabel('input 1'); ylabel('input 2'); title('o: class 1, x: class 2');
axis square; axis([-0.5 1.5 -0.5 1.5]);
grid on
