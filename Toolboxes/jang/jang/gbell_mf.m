function y = gbell_mf(x, parameter)

% GBELL_MF Generalized bell-shaped membership function with three parameters.
%	GBELL_MF(x, [a, b, c]) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.

%	Jyh-Shing Roger Jang, 6-28-93.

a = parameter(1); b = parameter(2); c = parameter(3);
y = 1./(1+(((x - c)/a).^2).^b);
