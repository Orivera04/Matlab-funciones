function getResponse(this, r, varargin)
% GETRESPONSE Update output signals

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:37 $

d = r.Data;
SimData = d.SimData;
[nport,nexp] = size(SimData);
if isempty( SimData(1).Time ) && strcmp( r.View.Visible,'on' )
  % Update data
  Estim = this.Estimation;
  EstimPorts = this.OutputPort;
  util = slcontrol.Utilities;
  % Loop over each experiment
  for idxExp=1:nexp
    % Get sim data
    Experiment = Estim.Experiments(idxExp);
    ExpPorts   = getPortHandles(Experiment,'NoSort');
    simulator  = Estim.getCurrentResponse( Experiment );
    
    % Localize experiment's output ports in sorted list of source ports
    [junk,idxOut,idxRow] = intersect(ExpPorts,EstimPorts);
    
    for ct=1:length(idxOut)
      [ys,ye,t] = LocalOutputData(simulator, idxOut(ct));
      SimData(idxRow(ct),idxExp).Time = t;
      SimData(idxRow(ct),idxExp).Amplitude = ys;
    end
  end
  d.SimData = SimData;
end

% -----------------------------------------------------------------------------
function [ys,ye,t] = LocalOutputData(simulator, idxOut)
% Evaluate output errors
DataLog    = simulator.DataLog.Data;
FailedSim  = isempty(DataLog);
ExpOut     = simulator.Experiment.OutputData(idxOut);
hOutport   = logSetup(simulator);

% Evaluate residuals for each experiment
util = slcontrol.Utilities;
% Get logged data
if FailedSim
  t = []; ys = []; ye = [];
else
  LogName   = get(hOutport(idxOut), 'DataLoggingName');
  Log       = findLog(util, DataLog, LogName);
  [ys,ye,t] = getLogData(util, ExpOut, Log);
end
