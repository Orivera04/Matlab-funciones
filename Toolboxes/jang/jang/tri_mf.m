function y = tri_mf(x, parameter)
% TRI_MF Triangular membership function with three parameters.
%	TRI_MF(x, [a, b, c]) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.

%	Jyh-Shing Roger Jang, 6-28-93.

a = parameter(1); b = parameter(2); c = parameter(3);
if a > b,
	error('Illegal parameters: a > b');
elseif b > c,
	error('Illegal parameters: b > c');
elseif a > c,
	error('Illegal parameters: a > c');
end

y = max(min((x-a)/(b-a), (c-x)/(c-b)), 0);
