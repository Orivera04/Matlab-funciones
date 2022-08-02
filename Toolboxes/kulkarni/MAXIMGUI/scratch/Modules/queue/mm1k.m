function cell_array = mm1k(l,m,K);

% Computes all results for a M/M/1/K queueing model, returns a cell array
% Usage: l: arrival rate;
%        m: service rate m;
%        K: capacity;
% Output array elements:  i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),
%                         i = 6 => y(j) = P(entering customer sees j-1 in system).

R = ex6ssq(l,m,K);
yy = ctmcod(R);

cell_array{1} = yy*[0:K]';

cell_array{2} = yy*[0 0:K-1]';

cell_array{3} = yy*[0:K]'/(l*(1-yy(K+1)));

cell_array{4} = yy*[0 0:K-1]'/(l*(1-yy(K+1)));

cell_array{5} = yy;

cell_array{6} = [yy(1:K) 0]/(1-yy(K+1));

