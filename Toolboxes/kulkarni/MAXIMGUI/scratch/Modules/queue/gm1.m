function cell_array = gm1(l,m,a);

% Computes results for a G/M/1 queueing model
% Usage: l: arrival rate;
%        m: service rate m;
%        a: solution to the functional equation;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),
%                         i = 6 => y(j) = p(arrival sees j-1 customers in the system).

rho = l/m;

cell_array{1} = rho/(1-a);

cell_array{2} = rho*a/(1-a);

cell_array{3} = 1/(m*(1-a));

cell_array{4} = a/(m*(1-a));

k = fix((-10-log(1-a))/log(a));
k=max(k,5);
cell_array{5} = [1-rho rho*geometricpmf(1-a,k)];

cell_array{6} = geometricpmf(1-a,k+1);

