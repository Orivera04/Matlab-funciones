function y = modsig(x, parameter)
%SIG_MF	Sigmoidal membership function with two parameters.
%	SIG_MF(x, [a, c]) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.

%	Jyh-Shing Roger Jang, 6-29-93.
%
% a = parameter(1); c = parameter(2);
y = 1./(1 + exp(-x));
