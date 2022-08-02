generation_n = 30;	% Number of generations
popuSize = 20;		% Population size
xover_rate = 1.0;	% Crossover rate
mutate_rate = 0.01;	% Mutation rate
bit_n = 8;		% Bit number for each input variable
global OPT_METHOD	% optimization method.
OPT_METHOD = 'ga';	% This is used for display in peaksfcn
figure;
blackbg;

obj_fcn = 'peaksfcn';	% Objective function: 'peaksfcn' or 'wavefcn'

if strcmp(obj_fcn, 'peaksfcn'),	% objective function is 'peaksfcn'
	var_n = 2;		% Number of input variables
	range = [-3, 3; -3, 3];	% Range of the input variables
	% Plot peaks function
	peaks;
	colormap((jet+white)/2);
	% Plot contours of peaks function
	figure;
	blackbg;
	[x, y, z] = peaks;
	pcolor(x,y,z); shading interp; hold on;
	contour(x, y, z, 20, 'r');
	hold off; colormap((jet+white)/2);
	axis square; xlabel('X'); ylabel('Y');
else				% objective function is 'wavefcn'
	var_n = 1;		% Number of input variables
	range = [0 pi];		% Range of the input variables
	x = linspace(range(1), range(2));
	y = sin(10*x).*sin(x);
	plot(x, sin(10*x).*sin(x));
	axis([-inf inf -inf inf]);
end

% Initial random population
popu = rand(popuSize, bit_n*var_n) > 0.5; 

upper = zeros(generation_n, 1);
average = zeros(generation_n, 1);
lower = zeros(generation_n, 1);

% Main loop of GA
for i = 1:generation_n;

	% delete unnecessary objects
	delete(findobj(0, 'tag', 'member'));
	delete(findobj(0, 'tag', 'individual'));
	delete(findobj(0, 'tag', 'count'));

	% Evaluate objective function for each individual
	fcn_value = evalpopu(popu, bit_n, range, obj_fcn);
%	if (i==1),
%		fprintf('Initial population.\n');
%		fprintf('Press any key to continue...\n');
%		pause;
%	end

	% Fill objective function matrices
	upper(i) = max(fcn_value);
	average(i) = mean(fcn_value);
	lower(i) = min(fcn_value);

	% display current best
	[best, index] = max(fcn_value);
	fprintf('Generation %i: ', i);
	if strcmp(obj_fcn, 'peaksfcn'),	% obj. function is 'peaksfcn'
		fprintf('f(%f, %f)=%f\n', ...
			bit2num(popu(index, 1:bit_n), range(1,:)), ...
			bit2num(popu(index, bit_n+1:2*bit_n), range(2,:)), ...
			best);
	else				% obj. function is 'wavefcn'
		fprintf('f(%f)=%f\n', bit2num(popu(index, :), range), best);
	end
	% generate next population via selection, crossover and mutation
	popu = nextpopu(popu, fcn_value, xover_rate, mutate_rate);
%	if (i==5),
%		fprintf('Population after the 5th generation.\n');
%		fprintf('Press any key to continue...\n');
%		pause;
%	end
%	if (i==10),
%		fprintf('Population after the 10th generation.\n');
%		fprintf('Press any key to continue...\n');
%		pause;
%	end
end

figure;
blackbg;
x = (1:generation_n)';
plot(x, upper, 'o', x, average, 'x', x, lower, '*');
hold on;
plot(x, [upper average lower]);
hold off;
legend('Best', 'Average', 'Poorest');
xlabel('Generations'); ylabel('Fitness');
