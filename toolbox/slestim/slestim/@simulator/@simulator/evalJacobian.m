function J = evalJacobian(this, GradModel, x, sL, sR, j)
% EVALJACOBIAN Compute jacobian of weighted errors.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/19 01:33:32 $

% Create gradient data log if empty
if isempty(this.GradLog)
  this.GradLog = struct( 'X', cell(size(x)), 'Data', [] );
end

if ~isequal(this.GradLog(j).X, x)
  % Simulate gradient model at x and compute outputs
  this.GradLog(j).X    = x;
  this.GradLog(j).Data = this.getCurrentResponseG(GradModel, sL, sR);
end
J = LocalEvalJacobian(this, this.GradLog(j).Data, GradModel);

% --------------------------------------------------------------------------- %
function J = LocalEvalJacobian(this, GradLog, GradModel)
% Evaluate error gradients
FailedSim  = isempty(GradLog);
Experiment = this.Experiment;
ExpOut     = Experiment.OutputData;
LeftPorts  = logSetup(this, [GradModel '/Left'],  '_L');
RightPorts = logSetup(this, [GradModel,'/Right'], '_R');

% Evaluate jacobians for each experiment
J = zeros(0,1);
util = slcontrol.Utilities;
for ct = 1:length(ExpOut)
  % Get logged data
  if FailedSim
    t = NaN; y = NaN;
    delta = LocalError(this,t,y,ExpOut(ct));
  else
    LeftLogName   = get(LeftPorts(ct),  'DataLoggingName');
    LeftLog       = findLog(util, GradLog, LeftLogName);
    [yL,dummy,tL] = getLogData(util, ExpOut(ct), LeftLog);

    RightLogName  = get(RightPorts(ct), 'DataLoggingName');
    RightLog      = findLog(util, GradLog, RightLogName);
    [yR,dummy,tR] = getLogData(util, ExpOut(ct), RightLog);
    
    delta = LocalError(this,tL,yL,ExpOut(ct))-LocalError(this,tR,yR,ExpOut(ct));
  end
  
  % Evaluate jacobian
  J = [J; delta];
end

% --------------------------------------------------------------------------- %
function J = LocalError(this,t,y,h)
if (length(t) == 1) && isnan(t)
  % Sim failure
  
  % Output times from experiment.
  t  = h.Time;
  tr = getSimTime(this);
  
  % Protect against empty experiment data
  if ~isempty(t)
    % Merge the time bases
    tmin = max( t(1),   tr(1) );
    tmax = min( t(end), tr(end) );
    ts = t(t>=tmin & t<=tmax);
    
    % Sim failure
    len = length(ts) * prod(h.Dimensions);
    J = zeros(len,1);
  else
    J = [];
  end
elseif isempty(y)
  % No output data
  J = [];
else
  J = y * diag(h.Weight(:)); % Weighted error
  J = J(:);
  
  % Safeguard against instability
  idx = find(~isfinite(J));
  J(idx) = 0;
end
