function y = exts_mf(x, para)

% EXTSMF S-shaped membership function with two or three parameters
%	para = [x_zero, x_one].
%	S_MF(x, para) returns a matrix y with the same size
%	as x; each element of y is a grade of membership.
%	EXTSMF return 0 and 1 when x = x_zero and x_one, respectively.
%	For example, try the following:
%
%		x = 0:0.1:10;
%		subplot(211);
%		plot(x, exts_mf(x, [3 8]));
%		subplot(212);
%		plot(x, exts_mf(x, [8 3]));
%
%	To show the effect the the third parameter, try:	
%
%		x = (0:0.1:10)';
%		all_mf = [];
%		for j = 0.1:0.1:3,
%			all_mf = [all_mf exts_mf(x, [3, 8, j])];
%		end
%		clf; subplot(211); plot(x, all_mf);

%	Roger Jang, 10-5-93.

if nargin ~= 2
	error('Two arguments are required by the S MF.');
end

if length(para) < 2
	error('The S MF needs at least two parameters.');
end

if isempty(x),
	y = [];
	return;
end

x_zero = para(1);
x_one = para(2);
if length(para) >= 3,
	exp_coef = para(3);
else
	exp_coef = 1;
end

if x_zero == x_one, 
	error('The S MF needs two distinct parameters.');
end

l = min(x_zero, x_one);;
r = max(x_zero, x_one);;
y = zeros(size(x));

index1 = find(x <= l);
y(index1) = zeros(size(index1));

index2 = find((l < x) & (x <= (l+r)/2));
tmp = 2*((x(index2)-l)/(r-l)).^2;
y(index2) = (tmp.^exp_coef)/(0.5^(exp_coef-1)); 

index3 = find(((l+r)/2 < x) & (x <= r));
tmp = 1-2*((r-x(index3))/(r-l)).^2;
y(index3) = 1 - ((1-tmp).^exp_coef)/(0.5^(exp_coef-1)); 

index4 = find(r <= x);
y(index4) = ones(size(index4));

if (l == x_one)
	y = 1-y;
end

