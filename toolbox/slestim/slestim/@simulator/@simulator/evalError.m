function R = evalError(this, x, j)
% EVALERROR Compute weighted errors between the simulated and experimental data.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/19 01:33:31 $

if j == 0
  if ~isequal(this.DataLog.X, x)
    % Simulate model at x and compute output errors
    this.DataLog.X    = x;
    this.DataLog.Data = this.getCurrentResponse;
  end
  R = real( LocalEvalError(this, this.DataLog.Data) );
else
  % Create gradient data log if empty
  if isempty(this.GradLog)
    this.GradLog = struct( 'X', cell(length(x),2), 'Data',[] );
  end
  
  idxLR = 1 + (j<0);
  j = abs(j);
  if ~isequal(this.GradLog(j,idxLR).X, x)
    % Simulate model at x and compute outputs
    this.GradLog(j,idxLR).X    = x;
    this.GradLog(j,idxLR).Data = this.getCurrentResponse;
  end
  R = LocalEvalError(this, this.GradLog(j,idxLR).Data);
end

% --------------------------------------------------------------------------- %
function R = LocalEvalError(this, DataLog)
% Evaluate output errors
FailedSim  = isempty(DataLog);
Experiment = this.Experiment;
ExpOut     = Experiment.OutputData;
hOutport   = logSetup(this);

% Evaluate residuals for each experiment
R = zeros(0,1);
util = slcontrol.Utilities;
for ct = 1:length(ExpOut)
  % Get logged data
  if FailedSim
    t = NaN; y = NaN;
  else
    LogName   = get(hOutport(ct), 'DataLoggingName');
    Log       = findLog(util, DataLog, LogName);
    [ys,ye,t] = getLogData(util, ExpOut(ct), Log);
    y = ys-ye;
  end
  
  % Evaluate residual
  R = [R; LocalError(this,t,y,ExpOut(ct))];
end

% --------------------------------------------------------------------------- %
function R = LocalError(this,t,y,h)
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
    R = (1e16 + i) * ones(len,1);
  else
    R = [];
  end
elseif isempty(y)
  % No output data
  R = [];
else
  R = y * diag(h.Weight(:)); % Weighted error
  R = R(:);
  
  % Safeguard against instability
  idx = find(~isfinite(R));
  R(idx) = 1e16 + i;
end
