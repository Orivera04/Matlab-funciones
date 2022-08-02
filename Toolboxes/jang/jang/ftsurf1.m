point_n = 25;
x = linspace(0, 10, point_n);
y = linspace(0, 10, point_n);
[xx, yy] = meshgrid(x, y);
zz = zeros(size(xx));

for p = 1:length(x),
	fprintf('Iteration count: %d\n', p);
	for q = 1:length(y),
		zz(p,q) = cartfis(xx(p,q), yy(p,q), 0);
	end
end

blackbg;
subplot(2,2,1);
mesh(xx, yy, zz);
xlabel('x'); ylabel('y'); zlabel('z');
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');

