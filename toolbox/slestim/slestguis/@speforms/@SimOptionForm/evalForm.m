function options = evalForm(this, ModelWS, ModelWSVars)
% Evaluates literal optimization settings in appropriate workspace.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:25:44 $

options = speoptions.SimOptions;
util = slcontrol.Utilities;

props = intersect(fieldnames(this), fieldnames(options));
numFields = { 'AbsTol', 'FixedStep', 'InitialStep', 'MaxStep', 'MinStep', ...
              'RelTol', 'StartTime', 'StopTime' };

for ct = 1:length(props)
  f = props{ct};
  
  if any( strcmp(numFields, f) )
    % Numeric fields
    if strcmp(this.(f), 'auto')
      options.(f) = 'auto';
    else
      [pv,Fail] = evalExpression(util, this.(f), ModelWS, ModelWSVars);
      if Fail
        error('Invalid simulation setting %s: variable %s not found.', ...
              f, this.(f))
      end
      options.(f) = pv;
    end
  else
    % Non-numeric fields
    options.(f) = this.(f);
  end
end
