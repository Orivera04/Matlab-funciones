function h = evalForm(this, ModelWS, ModelWSVars)
% EVALFORM Evaluates literal parameter settings in appropriate workspace
% and returns a @Parameter object with all-numeric values.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:15 $

Fields = {'InitialGuess', 'Minimum','Maximum','TypicalValue', 'Estimated'; ...
          'Initial Guess','Minimum','Maximum','Typical Value','Estimated Elements'};

util = slcontrol.Utilities;

% Create @Parameter object
[pv,Fail] = evalExpression(util, this.Name, ModelWS, ModelWSVars);
if Fail
  error('Cannot evaluate parameter %s', this.Name)
end
h = ParameterEstimator.Parameter(this.Name, pv);

% Evaluate other settings
for ct = 1:size(Fields,2)
  f = Fields{1,ct};
  [v,Fail] = evalExpression(util, this.(f), ModelWS, ModelWSVars);
  if Fail
    error( 'Cannot evaluate %s for parameter %s: variable %s not found.', ...
           Fields{2,ct}, this.Name, this.(f) )
  end
  
  try
    h.(f) = v;
  catch
    error('Invalid %s value for parameter %s.', Fields{2,ct}, this.Name)
  end
end

% Check min < max
if any(h.Minimum > h.Maximum)
  error('Invalid settings for parameter %s: Minimum exceeds Maximum', this.Name)
end

h.TypicalValue = abs(h.TypicalValue);
h.Estimated    = (h.Estimated ~= 0);
h.ReferencedBy = this.ReferencedBy;
h.Description  = this.Description;
