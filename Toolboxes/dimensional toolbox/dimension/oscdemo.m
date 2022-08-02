% OSCDEMO dimensional analysis for an oscillator

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-11

clc
echo on
% The equation of motion for a one degree of freedom
% oscillator is given by
%
%  m (d2x/dt2) + c (dx/dt) + k x = p f(t)
%
% with  m   ... mass
%       c   ... damping
%       k   ... stiffness
%       p   ... maximum ext. force
%       f(t)... external force (dimensionless)
%       t   ... time
%       x   ... position
%       v   ... velocitiy (dx / dt)
%       a   ... acceleration (d2x / dt2)
%

pause;  % press any key to continue

% These variables form the relevance list
% (a and v are not relevant since they are determined
% by x and t)
Names = {'m' ,'c'   ,'k'    ,'p','f','x','t'};
Units = {'kg','kg/s','kg/s2','N','1','m','s'};
RL    = rlist(Names,unit2si(Units));
%

pause;  % press any key to continue

% Now we determine the number of base variables
[nPi,nbase] = numpi(RL)
% So we have to select tree base variables and can
% get up to 4 dimensionless groups.
%
% Let's set the three base variables to be
bv = {'t','p','m'};

pause;  % press any key to continue

% Now we can perform the dimensional analysis
piset = diman(RL,bv);

pause;  % press any key to continue

% and display the resulting dimensionless groups
pretty(piset);

pause;  % press any key to continue

% We are not yet satisfied with the dimensionless
% groups. We take a look at the dimensional matrix
clear B
B(1,:)   = piset.Name;
B(2:4,:) = num2cell([piset.B piset.A])

% and select an appropriate D matrix to create another
% set of dimensionless groups
DN = {'c','k','f','x'};
D  = [ 1 -0.5 0 0; 0 1 0 1; 0 0 1 0; 0 0.5 0 0];
D  = created(RL,getdv(RL,bv),D,DN)

pause;  % press any key to continue

% Again we do a dimensional analysis, this time with the
% given D-submatrix
piset1 = diman(RL,bv,D);

% and take a look at this set of dimensionless groups
pretty(piset1);

pause;  % press any key to continue

% These dimensionless groups are entitled pi = 2D, 
% pi2 = xi, pi3 = f; pi4 = tau
%
% and the differential equation can be written as
%
% d2xi/dtau2 + 2D dxi/dtau + xi = f(tau/omega0)
% 
% mit omega0 = sqrt(k/m) since f is given in dimensional
% coordinates

echo off