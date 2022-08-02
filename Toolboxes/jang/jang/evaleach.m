function out = evaleach(string, bit_n, range, fcn)
% EVALEACH Evaluation of each individual's fitness value.
%	bit_n: number of bits for each input variable
%	string: bit string representation of an individual
%	range: range of input variables, a ver_n by 2 matrix
%	fcn: objective function (a MATLAB string)

var_n  = length(string)/bit_n;
input = zeros(1, var_n);
for i = 1:var_n,
	input(i) = bit2num(string((i-1)*bit_n+1:i*bit_n), range(i, :));
end
out = feval(fcn, input);
