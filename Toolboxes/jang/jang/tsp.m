function out = tsp(loc)
% TSP Traveling salesman problem (TSP) using SA (simulated annealing).
% 	TSP by itself will generate 20 cities within a unit cube and
%	then use SA to slove this problem.
%
%	TSP(LOC) solve the traveling salesman problem with cities'
%	coordinates given by LOC, which is an M by 2 matrix and M is
%	the number of cities.
%
% 	For example:
%
%		loc = rand(50, 2);
%		tsp(loc);

if nargin == 0,
% The following data is from the post by Jennifer Myers (jmyers@nwu.edu)
% to comp.ai.neural-nets. It's obtained from the figure in
% Hopfield & Tank's 1985 paper in Biological Cybernetics
% (Vol 52, pp. 141-152).

	loc = [0.3663, 0.9076; 0.7459, 0.8713; 0.4521, 0.8465;
		0.7624, 0.7459; 0.7096, 0.7228; 0.0710, 0.7426;
		0.4224, 0.7129; 0.5908, 0.6931; 0.3201, 0.6403;
		0.5974, 0.6436; 0.3630, 0.5908; 0.6700, 0.5908;
		0.6172, 0.5495; 0.6667, 0.5446; 0.1980, 0.4686;
		0.3498, 0.4488; 0.2673, 0.4274; 0.9439, 0.4208;
		0.8218, 0.3795; 0.3729, 0.2690; 0.6073, 0.2640;
		0.4158, 0.2475; 0.5990, 0.2261; 0.3927, 0.1947;
		0.5347, 0.1898; 0.3960, 0.1320; 0.6287, 0.0842;
		0.5000, 0.0396; 0.9802, 0.0182; 0.6832, 0.8515];
end
 
NumCity = length(loc);		% Number of cities
distance = zeros(NumCity);	% Initialize a distance matrix
% Fill the distance matrix
for i = 1:NumCity,
	for j = 1:NumCity,
		distance(i, j) = norm(loc(i, :) - loc(j, :));
	end
end

% To generate energy (objective function) from path
%path = randperm(NumCity);
%energy = sum(distance((path-1)*NumCity + [path(2:NumCity) path(1)]));

% Find typical values of dE
count = 20;
all_dE = zeros(count, 1);
for i = 1:count
	path = randperm(NumCity);
	energy = sum(distance((path-1)*NumCity + [path(2:NumCity) path(1)]));
	new_path = path;
	index = round(rand(2,1)*NumCity+.5);
	inversion_index = (min(index):max(index));
	new_path(inversion_index) = fliplr(path(inversion_index));
	all_dE(i) = abs(energy - ...
		sum(sum(diff(loc([new_path new_path(1)],:))'.^2)));
end
dE = max(all_dE);

temp = 10*dE;	% Choose the temperature to be large enough
fprintf('Initial energy = %f\n\n',energy);

% Initial plots
out = [path path(1)];
plot(loc(out(:), 1), loc(out(:), 2),'r.', 'Markersize', 20);
axis square; hold on
h = plot(loc(out(:), 1), loc(out(:), 2)); hold off
 
MaxTrialN = NumCity*100;		% Max. # of trials at a temperature
MaxAcceptN = NumCity*10;		% Max. # of acceptances at a temperature
StopTolerance = 0.005;		% Stopping tolerance
TempRatio = 0.5;		% Temperature decrease ratio
minE = inf;			% Initial value for min. energy
maxE = -1;			% Initial value for max. energy

% Major annealing loop
while (maxE - minE)/maxE > StopTolerance,
	minE = inf;
	maxE = 0;
	TrialN = 0;		% Number of trial moves
	AcceptN = 0;		% Number of actual moves 
	while TrialN < MaxTrialN & AcceptN < MaxAcceptN,
		new_path = path;
		index = round(rand(2,1)*NumCity+.5);
		inversion_index = (min(index):max(index));
		new_path(inversion_index) = fliplr(path(inversion_index)); 
		new_energy = sum(distance( ...
			(new_path-1)*NumCity+[new_path(2:NumCity) new_path(1)]));
		if rand < exp((energy - new_energy)/temp),	% accept it!
			energy = new_energy;
			path = new_path;
			minE = min(minE, energy);
			maxE = max(maxE, energy);
			AcceptN = AcceptN + 1;
		end
		TrialN = TrialN + 1;
	end

	% Update plot
	out = [path path(1)];
	set(h, 'xdata', loc(out(:), 1), 'ydata', loc(out(:), 2));
	drawnow;
	% Print information in command window 
	fprintf('temp. = %f\n', temp);
	tmp = sprintf('%d ',path);
	fprintf('path = %s\n', tmp);
	fprintf('energy = %f\n', energy);
	fprintf('[minE maxE] = [%f %f]\n', minE, maxE);
	fprintf('[AcceptN TrialN] = [%d %d]\n\n', AcceptN, TrialN);
	% Lower the temperature
	temp = temp*TempRatio;
end
 
% Print sequential numbers in the graphic window
for i = 1:NumCity,
	text(loc(path(i),1)+0.01, loc(path(i),2)+0.01, int2str(i), ...
		'fontsize', 8);
end
