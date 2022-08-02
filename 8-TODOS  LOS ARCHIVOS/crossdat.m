% Data set: crossdat
% ~~~~~~~~~~~~~~~~~~
%
% Data specifying a cross shaped truss.
%
%----------------------------------------------

% Nodal point data are defined by:
%   x - a vector of x coordinates
%   y - a vector of y coordinates
x=10*[.5 2.5 1 2 0 1 2 3 0 1 2 3 1 2];
y=10*[ 0   0 1 1 2 2 2 2 3 3 3 3 4 4];

% Element data are defined by:
%   inode - index vector defining the I-nodes
%   jnode - index vector defining the J-nodes
%   elast - vector of elastic modulus values
%   area  - vector of cross section area values
%   rho   - vector of mass per unit volume 
%           values
inode=[1 1 2 2 3 3 4 3 4 5 6 7 5 6 6 6 7 7 7 ...
       8 9 10 11 10 11 10 11 13];
jnode=[3 4 3 4 4 6 6 7 7 6 7 8 9 9 10 11 10 ...
       11 12 12 10 11 12 13 13 14 14 14];
elast=3e7*ones(1,28);
area=ones(1,28); rho=ones(1,28);

% Any points constrained against displacement 
% are defined by:
%   idux - indices of nodes having zero 
%          x-displacement
%   iduy - indices of nodes having zero 
%          y-displacement
idux=[1 2]; iduy=[1 2];
