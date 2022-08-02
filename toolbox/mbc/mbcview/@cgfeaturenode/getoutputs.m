function list=getoutputs(obj)
%GETOUTPUTS
%
%  Returns an N*2 cell array with one row for each quantity which can be
%  calculated for this feature.  The first element in each row contains the
%  name of the quantity, and the second, a handle for the function which
%  calculates it.
%  The function has the prototype:
%    out = func(obj,inputs)
%  where obj is the feature node, inputs are the variables to grid over and
%  the return value is a matrix with dimensions determined by the cgvalue
%  instances which the feature takes as inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.4 $  $Date: 2004/04/04 03:33:06 $ 

list = {'Strategy', @i_CalcStrategy;
        'Model', @i_CalcModel;
        'Prediction error', @i_CalcPE;
        'Error (strategy-model)', @i_CalcError };


%---------------------------------
function out=i_CalcModel(obj, vars)

if ~isa(obj,'cgfeaturenode')
	error('Object is not a cgfeaturenode');
end

feature = getdata(obj);
model = feature.get('model');
if isempty(model)
    out = 'No model to evaluate';
elseif model.isSwitchExpr
    out = 'Cannot plot switching model';
else
    minputs = model.getinports; 
    in = ~cgisindependentvars(vars, minputs); 
    if ~all(in) 
        out = 'The model does not depend on the specified variables';
    else
        out = model.evaluategrid(vars);
    end
end

%-------------------------------
function out=i_CalcStrategy(obj, vars)

if ~isa(obj,'cgfeaturenode')
	error('Object is not a cgfeaturenode');
end

feature = getdata(obj);
finputs = feature.getinports;
if ~all(ismember(vars,finputs))
    out = 'The strategy does not depend on the specified variables';
else
    out = feature.evaluategrid(vars);
end


%-------------------------------
function out=i_CalcPE(obj, vars)

if ~isa(obj,'cgfeaturenode')
	error('Object is not a cgfeaturenode');
end

feature = getdata(obj);
model = feature.get('model');
if isempty(model)
    out = 'No model to evaluate';
elseif model.isSwitchExpr
    out = 'Cannot plot prediction error for a switching model';
else
    if pevcheck(model.info)
        out = model.evaluategrid(vars, 'pev');
    else
        out='Prediction error is not defined for this model';
    end
end


%-------------------------------
function out = i_CalcError(obj, vars)

out = [];
mod = i_CalcModel(obj, vars);
if ischar(mod)
    out = mod;
elseif ~isempty(mod)
	strat = i_CalcStrategy(obj, vars);
    if ischar(strat)
        out = strat;
    else
        out = strat - mod;
    end
end
