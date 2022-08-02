figH = genfig('Typical Initial MFs');

point_n = 100;
x = linspace(0, 12, point_n);
params = [2 2 0;
	2 2 4;
	2 2 8;
	2 2 12];

mf = zeros(4, point_n);

for i=1:4,
	mf(i, :) = gbell_mf(x, params(i, :));
end

blackbg;
subplot(211)
plot(x', mf');
xlabel('Input Variable');
ylabel('Membership Grade');
axis([-inf inf 0 1.2]);

cyclesty;
