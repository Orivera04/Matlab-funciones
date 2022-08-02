function new_popu = nextpopu(popu, fitness, xover_rate, mut_rate)

new_popu = popu;
popu_s = size(popu, 1);
string_leng = size(popu, 2);

% ====== ELITISM: find the best two and keep them
tmp_fitness = fitness;
[junk, index1] = max(tmp_fitness);	% find the best
tmp_fitness(index1) = min(tmp_fitness);
[junk, index2] = max(tmp_fitness);	% find the second best
new_popu([1 2], :) = popu([index1 index2], :);

% rescaling the fitness
fitness = fitness - min(fitness);	% keep it positive
total = sum(fitness);
if total == 0,
	fprintf('=== Warning: converge to a single point ===\n');
	fitness = ones(popu_s, 1)/popu_s;	% sum is 1
else
	fitness = fitness/sum(fitness);		% sum is 1
end
cum_prob = cumsum(fitness);

% ====== SELECTION and CROSSOVER
for i = 2:popu_s/2,
	% === Select two parents based on their scaled fitness values
	tmp = find(cum_prob - rand > 0);
	parent1 = popu(tmp(1), :);
	tmp = find(cum_prob - rand > 0);
	parent2 = popu(tmp(1), :);
	% === Do crossover
	if rand < xover_rate,
		% Perform crossover operation
		xover_point = ceil(rand*(string_leng-1));
		new_popu(i*2-1, :) = ...
		    [parent1(1:xover_point) parent2(xover_point+1:string_leng)];
		new_popu(i*2, :) = ...
		    [parent2(1:xover_point) parent1(xover_point+1:string_leng)];
	end
%	fprintf('xover_point = %d\n', xover_point);
%	disp(parent1);
%	disp(parent2);
%	disp(new_popu(i*2-1, :));
%	disp(new_popu(i*2, :));
%	keyboard;
end

% ====== MUTATION (elites are not subject to this.)
mask = rand(popu_s, string_leng) < mut_rate;
new_popu = xor(new_popu, mask);
% restore the elites
new_popu([1 2], :) = popu([index1 index2], :);

