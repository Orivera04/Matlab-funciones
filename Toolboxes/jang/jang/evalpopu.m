function fitness = evalpopu(population, bit_n, range, fcn)
%EVALPOPU Evaluation of the population's fitness values.
%	population: 0-1 matrix of popu_n by string_leng
%	bit_n: number of bits used to represent an input variable 
%	range: range of input variables, a var_b by 2 matrix
%	fcn: objective function (a MATLAB string)

global count

pop_n = size(population, 1);
fitness = zeros(pop_n, 1);
for count = 1:pop_n,
	fitness(count) = evaleach(population(count, :), bit_n, range, fcn);
end
