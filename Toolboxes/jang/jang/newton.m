x = linspace(1, 10, 10)';
y = [10 7 5 4 3.5 3.2 2 1 2 4]';
order = 9;
coef = polyfit(x, y, order);
xx = linspace(1, 10)';
yy = polyval(coef, xx);
limit = [min(x) max(x) min(y) max(y)];

d_coef = [length(coef)-1:-1:1].*coef(1:length(coef)-1);
dd_coef = [length(d_coef)-1:-1:1].*d_coef(1:length(d_coef)-1);

quadratic = zeros(100, 10);
for k = 1:10,
	quadratic(:, k) = 0.5*polyval(dd_coef, x(k))*(xx-x(k)).^2 + ...
		polyval(d_coef, x(k))*(xx-x(k)) + polyval(coef, x(k));
end

h = plot(x, y, '*', xx, yy, '-', xx, quadratic);
set(h(1:2), 'linewidth', 3);
axis(limit);
