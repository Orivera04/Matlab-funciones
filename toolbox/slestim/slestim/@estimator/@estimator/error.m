function R = error(this, x, j)
% ERROR Evaluate the residuals between the simulated and experimental data.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:43:20 $

Estimation = this.Estimation;
Simulators = Estimation.Simulators;

% X -> parameter/state object values
this.var2obj(x);

% Update parameter values in appropriate workspace.
Estimation.assignin(Estimation.Parameters);

% Evaluate error vector
R = [];
for ct = 1:length(Simulators)
  R = [ R; evalError(Simulators(ct), x, j) ];
end
