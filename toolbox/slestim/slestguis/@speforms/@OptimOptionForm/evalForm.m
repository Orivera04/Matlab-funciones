function options = evalForm(this, ModelWS, ModelWSVars)
% Evaluates literal optimization settings in appropriate workspace.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/10 21:52:34 $

options = speoptions.OptimOptions;
util = slcontrol.Utilities;

props = intersect(fieldnames(this), fieldnames(options));
numFields = { 'MaxIter', 'MaxFunEvals', 'TolCon', 'TolFun', 'TolX', ...
              'DiffMaxChange', 'DiffMinChange' };

for ct = 1:length(props)
  f = props{ct};
  
  if any( strcmp(numFields, f) )
    % Numeric fields
    [pv,Fail] = evalExpression(util, this.(f), ModelWS, ModelWSVars);
    if Fail
      error('Invalid optimization setting %s: variable %s not found.', ...
            f, this.(f))
    end
    options.(f) = pv;
  else
    % Non-numeric fields
    options.(f) = this.(f);
  end
end

% Search method and limit for GADS
if strcmp(this.Algorithm, 'patternsearch')
  switch this.SearchMethod
  case 'None'
    options.SearchMethod = [];
  case 'Positive Basis Np1'
    options.SearchMethod = @PositiveBasisNp1;
  case 'Positive Basis 2N'
    options.SearchMethod = @PositiveBasis2N;
  case 'Genetic Algorithm'
    options.SearchMethod = @searchga;
  case 'Latin Hypercube'
    [pv,Fail] = evalExpression(util, this.SearchLimit, ModelWS, ModelWSVars);
    if Fail
      error(['Invalid optimization setting for search iteration limit.\n' ...
             'Variable %s not found.'], this.SearchLimit)
    end
    options.SearchMethod = {@searchlhs pv};
  case 'Nelder-Mead'
    options.SearchMethod = @searchneldermead;
  end
else
  options.SearchMethod = [];
end
