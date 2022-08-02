function y = lr_mf(x, parameter)
%LR_MF Left-right membership function with 3 parameters.

% J.-S. Roger Jang, 1993

c = parameter(1); alpha = parameter(2); beta = parameter(3);
index1 = find(x < c);
index2 = find(x >= c);
x1 = (c - x(index1))/alpha;
x2 = (x(index2) - c)/beta;
y1 = sqrt(max(1-x1.*x1, zeros(size(x1))));
y2 = exp(-abs(x2.*x2.*x2));
if size(x, 1) == 1,
	y = [y1 y2];
else
	y = [y1; y2];
end
