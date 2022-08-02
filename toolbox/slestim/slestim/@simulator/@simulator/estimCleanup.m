function estimCleanup(this)
% Performs sunset tasks when estimation stops.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/24 21:12:44 $

try
  % Recompute current response if last logged X is not the optimal (final) X.
  if isempty(this.DataLog.X)
    DataLog = getCurrentResponse(this);
  else
    DataLog = this.Datalog.Data;
  end
  
  % Notify related constraint editors to update their plots
  E = ctrluis.dataevent(this, 'EstimStop', DataLog);
  this.send('EstimStop', E)
end
