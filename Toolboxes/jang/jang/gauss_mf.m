function y = gauss_mf(x, parameter)
%GAUSS_MF Gaussian membership function with two parameters.
%	GAUSSIAN(x, [sigma, c]) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.

%	Jyh-Shing Roger Jang, 6-29-93.

c = parameter(1);
sigma = parameter(2);
tmp = (x - c)/sigma;
y = exp(-tmp.*tmp/2);
