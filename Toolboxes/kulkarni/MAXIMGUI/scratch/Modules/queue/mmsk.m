function cell_array = mmsk(l,m,s,K);

% Computes results for a M/M/s/K queueing model
% Usage: l: arrival rate;
%        m: service rate m;
%        s: number of servers;
%        K: capacity;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),
%                         i = 6 => y(j) = P(entering customer sees j-1 in system).
%                         i = 7 => y = mean number of busy servers,
%                         i = 8 => y = P(an arriving customer has to wait).

R = ex6cc(l,m,s,K-s);
yy = ctmcod(R);

cell_array{1} = yy*[0:K]';

cell_array{2} = yy(s+1:K+1)*[0:K-s]';

cell_array{3} = yy*[0:K]'/(l*(1-yy(K+1)));

cell_array{4} = yy(s+1:K+1)*[0:K-s]'/(l*(1-yy(K+1)));

cell_array{5}= yy;

cell_array{6} = [yy(1:K) 0]/(1-yy(K+1));

cell_array{7} = l*(1-yy(K+1))/m;

cell_array{8} = yy*[0*ones(1,s) ones(1,K-s+1)]';

