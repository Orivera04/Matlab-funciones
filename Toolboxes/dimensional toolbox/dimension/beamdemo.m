%function piset = beamdemo()
% BEAMDEMO  cantilever beam demo for DA toolbox

% Dimensional Analysis Toolbox for Matlab
% Version 1.0
% Steffen Brueckner, 2002-02-09


if any(get(0,'children') == 3), close(3), end
echo on
clc
% The (known) equation for a cantilever beam with a contentrated
% force is given by

%  d = k * (P*l^3)/(E*I)

% where d is the tip deflection, k a dimensionless factor, P the
% tip force, l the beam length, E the Young's modulus and I the
% moment of inertia

pause % strike any key to continue

% The relevance list is now given by:

% Variable Names

N = {'d','k','P','l','E'    ,'I'};

% Variable units

u = {'m','1','N','m','N/m2','m4'};

% Note: The unit of the dimensionless factor k is "1"

pause % strike any key to continue

% Now we create the relevance list

RL = rlist(N,unit2si(u));

% Note: unit2si converts the given unit string names
% in a matrix with dimensional information and the
% according transformation factors for the data

RL = rlist(N,unit2si(u));

pause % strike any key to continue

% Let''s take a look at the relevance list entry for d

RL(1)
RL(1).Dimension'

pause % strike any key to continue

% Now it's time to choose the base variables

bv = {'E','l'};

pause % strike any key to continue

% And perform the dimensional analysis

piset = diman(RL,bv);

pause % strike any key to continue

% Ok, that''s the dimensional set now:
piset.A
piset.B
piset.C
piset.D
{piset.Name{piset.order}}

pause % strike any key to continue

% and the dimensionless numbers are
pretty(piset);
