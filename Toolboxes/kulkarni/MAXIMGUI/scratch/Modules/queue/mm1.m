function cell_array = mm1(l,m);

% Computes results for a M/M/1 queueing model
% Usage: l: arrival rate;
%        m: service rate m;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),

rho = l/m;

cell_array{1} = rho/(1-rho);

cell_array{2} = rho^2/(1-rho);

cell_array{3} = 1/(m-l);

cell_array{4} = rho/(m-l);

k = fix((-10 - log(1-rho))/log(rho));
cell_array{5} = geometricpmf(1-rho,max(k,5));

