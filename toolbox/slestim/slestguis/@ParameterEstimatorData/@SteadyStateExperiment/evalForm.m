function h = evalForm(this, h)
% EVALFORM Evaluates literal experiment settings in appropriate workspace
% and returns a @SteadyStateExperiment object with all-numeric values.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:50 $

% Populate properties
for k = 1:length(h.InputData)
  build( this.InputData(k), h.InputData(k) );
end

for k = 1:length(h.OutputData)
  build( this.OutputData(k), h.OutputData(k) );
end

for k = 1:length(h.StateData)
  evalForm( this.StateData(k), h.StateData(k) );
end
