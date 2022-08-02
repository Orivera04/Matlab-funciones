function varargout = spheredemo()
% SPHEREDEMO demo for dimensional analysis
% requires symbolic math toolbox!

% Steffen Brueckner, 2002-02-06

disp(' ');
disp('-------------------------------');
disp('SPHEREDEMO');
disp('Example for the calculation of');
disp('dimensionless groups (pis) for');
disp('a sphere in a flow with the ');
disp('parameters drag force D,');
disp('velocity v, diameter d, viscosity');
disp('nu and density rho');

disp(' ');
disp('This example requires the symbolic');
disp('math toolbox for a pretty display!');

% 1st alternative
  N = {'D','v'  ,'d','nu'  ,'rho'};
  d = {'N','m/s','m','m2/s','kg/m3'};
  [D,F] = unit2si(d);
  RL = rlist(N,D,F);

% 2nd alternative
% RL = [];
% RL = rlist(RL,'D',[1 1 -2],1);
% RL = rlist(RL,'v',[0 1 -1],1);
% RL = rlist(RL,'d',[0 1 0],1);
% RL = rlist(RL,'nu',[0 2 -1],1);
% RL = rlist(RL,'rho',[1 -3 0],1);

% 3rd alternative
%   N = {'D','v'  ,'d','nu'  ,'rho'};
%   D = [ 1  1 -2; ...
%         0  1 -1; ...
%         0  1  0; ...
%         0  2 -1; ...
%         1 -3  0];
% RL = rlist(N,D);


p = diman(RL,{'d','v','rho'});

disp(' ');
disp('-------------------------------');
disp('results in matrix form');
disp('-------------------------------');
disp(p.Name);
disp(num2cell([p.B p.A ; p.D p.C]));

disp(' ');
disp('-------------------------------');
disp('pretty print of the pis ');
disp('-------------------------------');
pretty(p);

% return piset if return variable is requested
if nargout == 1
    varargout{1} = p;
end