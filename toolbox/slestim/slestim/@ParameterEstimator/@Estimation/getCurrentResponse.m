function simulator = getCurrentResponse(this, Experiment)
% GETCURRENTRESPONSE Simulate the model and return output data

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/16 22:21:49 $

util = slcontrol.Utilities;

% See if there already is simulated data for this experiment
SimExps = get(this.Simulators, {'Experiment'});
idx = find([SimExps{:}] == Experiment);
if ~isempty(idx)
  simulator = this.Simulators(idx);
else
  simulator = simulator.simulator(Experiment, [], this.SimOptions);
end

% Initialize data logging settings
RunFlag = ~strcmp(this.EstimStatus, 'run');
if RunFlag
  this.EstimStatus = 'run';
end

% Save current parameter values
pv = evalParameters( util, this.Model, get(this.Parameters, {'Name'}) );

% Update parameter values in appropriate workspace.
this.assignin(this.Parameters);

% Recompute current response if last logged X is not the current best X.
try
  if isempty(simulator.DataLog.X)
    simulator.DataLog.Data = getCurrentResponse(simulator);
  end
end

% Restore data logging settings
if RunFlag
  this.EstimStatus = 'idle';
end

% Restore current parameter values
util.assignParameters(this.Model, pv)
