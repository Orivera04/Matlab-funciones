function initpar(this)
% Initializes estimated parameters to their current value
% in the model or base workspace.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/04/04 03:41:53 $

util = slcontrol.Utilities;
pv = evalParameters( util, this.Model, get(this.Parameters, {'Name'}) );
for ct = 1:length(this.Parameters)
  this.Parameters(ct).InitialGuess = pv(ct).Value;
end
