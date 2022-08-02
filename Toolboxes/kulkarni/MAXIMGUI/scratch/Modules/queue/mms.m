function cell_array = mms(l,m,s);

% Computes results for a M/M/s queueing model
% Usage: l: arrival rate;
%        m: service rate m;
%        s: number of servers;
% Output vector elements: i = 1 => y = mean number in system,
%                         i = 2 => y = mean number in queue,
%                         i = 3 => y = mean waiting time of entering customers,
%                         i = 4 => y = mean queueing time of entering customers,
%                         i = 5 => y(j) = P(j-1 in system),
%                         i = 6 => y = mean number of busy servers,

rho = l/(s*m);
yy = exp(l/m)*poissonpmf(l/m,s);
normf = sum(yy(1:s)) + yy(s+1)/(1-rho);
yy = yy/normf;

cell_array{1} = l/m + yy(s+1)*rho/(1-rho)^2;

cell_array{2} = yy(s+1)*rho/(1-rho)^2;

cell_array{3} = 1/m + yy(s+1)/(s*m*(1-rho)^2);

cell_array{4} = yy(s+1)/(s*m*(1-rho)^2);

k = max(s+3,fix((-10-log(yy(s+1)))/log(rho)));
cell_array{5} = [yy(1:s) yy(s+1)*rho.^[0:max(0,k-s)] ];

cell_array{6} = l/m;  

