function syncEstimation(this, x)
% Syncs parameter data with current best x and clears last data log if for a
% different x.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/24 21:12:34 $

Estimation = this.Estimation;
Simulators = Estimation.Simulators;

% X -> parameter/state object values
this.var2obj(x);

% Update parameter values in appropriate workspace.
Estimation.assignin(Estimation.Parameters);

% Look for out-of-sync data logs
% RE: When using search algorithms, best x is typically not the last value tried
for ct = 1:length(Simulators)
  sct = Simulators(ct);
  if isempty(sct.DataLog.Data)
    sct.DataLog.X = [];
  else
    % Check if last log is for the best current x
    xlog = sct.DataLog.X;
    if isempty(sct.DataLog.Data) || ~isequal(x(1:length(xlog)),xlog)
      % Clear cached values to force reevaluation at x
      sct.DataLog.X = [];
    end
  end
end
