function y = trap_mf(x, parameter)
% TRAP_MF Trapezoidal membership function with four parameters.
%	TRAP_MF(x, [a, b, c, d]) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.

%	Jyh-Shing Roger Jang, 6-28-93.

a = parameter(1); b = parameter(2); c = parameter(3); d = parameter(4);
if a > b,
	error('Illegal parameters: a > b');
elseif b > c,
	error('Illegal parameters: b > c');
elseif c > d,
	error('Illegal parameters: c > d');
end

y = max(min(min((x-a)/(b-a), (d-x)/(d-c)), 1), 0);
