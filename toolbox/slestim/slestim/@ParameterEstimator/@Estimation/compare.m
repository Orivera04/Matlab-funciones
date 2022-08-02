function compare(this, Experiment)
% COMPARE  Compare estimation results with experiment data provided.
%          Used mostly for validation.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:42:09 $

if ~isa(Experiment, 'ParameterEstimator.Experiment')
  error('Experiment must be supplied.')
end

% Create simulator objects
if size(this.States, 2) > 1
  States = this.States(:,1);
else
  States = this.States;
end

simulator = simulator.simulator(Experiment, States, this.SimOptions);

% Change status to 'run' (see setFunction for side effects)
this.EstimStatus = 'run';

% Simulate model and evaluate outputs
DataLog    = simulator.getCurrentResponse;
FailedSim  = isempty(DataLog);
ExpOut     = Experiment.OutputData;
hOutport   = logSetup(simulator);

% Evaluate residuals for each experiment
util = slcontrol.Utilities;
figure
hold on
for ct = 1:length(ExpOut)
  % Get logged data
  if FailedSim
    Log = struct('Time', NaN, 'Data', NaN);
  else
    LogName = get(hOutport(ct), 'DataLoggingName');
    Log = util.findLog(DataLog, LogName);
  end
  
  % Plot
  plot( ExpOut(ct).Time, ExpOut(ct).Data, 'b:', Log.Time, Log.Data, 'r--' );
end

% Return to idle status
this.EstimStatus = 'idle';
