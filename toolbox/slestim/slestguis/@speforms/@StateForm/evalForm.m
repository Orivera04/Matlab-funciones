function h = evalForm(this, ModelWS, ModelWSVars)
% EVALFORM Evaluates literal state settings in appropriate workspace
% and returns a @State object with all-numeric values.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:19 $

Fields = { ...
    'InitialGuess', 'Minimum','Maximum','TypicalValue', 'Ts','Estimated'; ...
    'Initial Guess','Minimum','Maximum','Typical Value','Ts','Estimated Elements'};

util = slcontrol.Utilities;

% Create @State object
[pv,Fail] = evalExpression(util, this.Value, ModelWS, ModelWSVars);
if Fail
  error('Cannot evaluate state %s', this.Block)
end
h = ParameterEstimator.State(this.Block, pv);

% Evaluate other settings
for ct = 1:size(Fields,2)
  f = Fields{1,ct};
  [v,Fail] = evalExpression(util, this.(f), ModelWS, ModelWSVars);
  if Fail
    error( 'Cannot evaluate %s for state %s: variable %s not found.', ...
           Fields{2,ct}, this.Block, this.(f) )
  end
  
  try
    h.(f) = v;
  catch
    error('Invalid %s value for state %s.', Fields{2,ct}, this.Block)
  end
end

% Check min < max
if any(h.Minimum > h.Maximum)
  error('Invalid settings for state %s: Minimum exceeds Maximum', this.Block)
end

h.TypicalValue = abs(h.TypicalValue);
h.Estimated    = (h.Estimated ~= 0);
h.Description  = this.Description;
