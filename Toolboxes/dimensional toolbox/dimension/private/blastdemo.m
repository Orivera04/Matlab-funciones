clc
echo on
% G.I. Taylor: Energiy in an nucelar explosion
%
% define the liste of relevant variables and
% their respective dimensions
N = {'R', 't', 'rho',   'E'};
u = {'m', 's', 'kg/m3', 'W'};

pause;  % press any key to continue

% form a relevance list
[d,f] = unit2si(u);
RL = rlist(N,d,f);

pause;  % press any key to continue

% check the number of possible dimensionless groups
numpi(RL)
%
% and choose the base variables
bv = {'t','rho','E'};
%
% and do the dimensional analysis
piset = diman(RL,bv);

pause;  % press any key to continue

% and print the resulting dimensionless group
pretty(piset);
%
% since we only have one dimensionless group, this
% must be a constant. Using e.g. the symbolic math
% toolbox the relationship
%
%             E t^2
%   E = pi1 (-------)^(1/5)
%               R
%
% can be established and the constant pi1 can be found
% from one observation only.
echo off