function cell_array = mg1(l,m,s2);

% Computes results for a M/G/1 queueing model
% Usage: l: arrival rate;
%        m: service rate m;
%        s2: variance of the service time;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y = p(server busy).

rho = l*m;

cell_array{1} = rho + .5*l^2*(s2+m^2)/(1-rho);

cell_array{2} = .5*l^2*(s2+m^2)/(1-rho);

cell_array{3} = m+ .5*l*(s2+m^2)/(1-rho);

cell_array{4} = .5*l*(s2+m^2)/(1-rho);

cell_array{5} = rho;
  
