function cell_array = mminf(l,m);

% Computes results for a M/M/inf queueing model
% Usage: l: arrival rate;
%        m: service rate m;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),
%                         i = 6 => y = mean number of busy servers,

cell_array{1} = l/m;

cell_array{2} = 0;

cell_array{3} = 1/m;

cell_array{4} = 0;

k = max(15,fix(l/m + 5*sqrt(l/m)));
cell_array{5} = poissonpmf(l/m,k);

cell_array{6} = l/m;  

