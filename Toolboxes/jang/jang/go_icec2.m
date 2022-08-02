close all
generation_n = 50;	% Number of generations
popuSize = 20;		% Population size
xover_rate = 1.0;	% Crossover rate
mutate_rate = 0.01;	% Mutation rate
bit_n = 16;		% Bit number for each input variable

obj_fcn = 'objfcn';	% Objective function

var_n = 2;		% Number of input variables
range = [-3, 3; -3, 3];	% Range of the input variables

test_n = 100;
GA_perf = zeros(test_n, 1);
GA_time = zeros(test_n, 1);
RS_perf = zeros(test_n, 1);
RS_time = zeros(test_n, 1);

for I = 1:test_n,
fprintf('I = %g\n', I);
ga_perf = zeros(generation_n, 1);

% Initial random population
opti = [0.02, 1.56];
popu = zeros(popuSize, bit_n*var_n);
init_x = zeros(popuSize, 2);	% for use with random search
i = 1;
while i < popuSize,
	tmp_popu = rand(1, bit_n*var_n) > 0.5; 
	x = bit2num(tmp_popu(1, 1:bit_n), range(1,:));
	y = bit2num(tmp_popu(1, bit_n+1:2*bit_n), range(2,:));
	r = norm([x y] - opti);
	if r > 1,
		popu(i, :) = tmp_popu;
		init_x(i, :) = [x y];
		i = i+1;
	end
end

% Main loop of GA
t0 = clock;
for i = 1:generation_n;

	% Evaluate objective function for each individual
	fcn_value = evalpopu(popu, bit_n, range, obj_fcn);

	% Fill objective function matrices
	ga_perf(i) = max(fcn_value);

	% generate next population via selection, crossover and mutation
	popu = nextpopu(popu, fcn_value, xover_rate, mutate_rate);
end
GA_time(I) = etime(clock, t0);

% Random search
rs_perf = zeros(popuSize, 1);

% Main loop for random search
t0 = clock;
for i = 1:popuSize,
	[x, rs_perf(i)] = randsh(obj_fcn, init_x(i, :), range, 50);
end
RS_time(I) = etime(clock, t0);

%fprintf('GAs: %g\n', max(ga_perf));
%fprintf('RS: %g\n', max(rs_perf));
GA_perf(I) = max(ga_perf);
RS_perf(I) = max(rs_perf);
end

%plot(1:test_n, GA_perf, 'o', 1:test_n, RS_perf, 'x');
figure;
stem(1:test_n, RS_perf-GA_perf);
figure;
plot(1:test_n, GA_time, 'o', 1:test_n, RS_perf, 'x',...
	1:test_n, GA_time, '-', 1:test_n, RS_perf, '-');
legend('GA', 'Random Search');

%save file2 GA_perf RS_perf GA_time RS_time
