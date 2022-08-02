point_n = 1001;
x = linspace(-1, 1, point_n);
y = zeros(size(x));
beta = 35;

for i = 1:point_n,
	y(i) = 1;
	for n = 0:beta,
		y(i) = y(i) + abs(2^n*x(i) - floor(2*x(i)))/(2^n);
	end
end

plot(x, y);

