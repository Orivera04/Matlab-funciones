function list=getoutputs(obj)
%GETOUTPUTS
%
%  LIST =GETOUTPUTS(ND) Returns an N*2 cell array with one row for each
%  quantity which can be calculated for this model.  The first element in
%  each row contains the name of the quantity, and the second, a handle for
%  the function which calculates it.
%
%  The function has prototype:
%     out=func(obj, inputs)
%  where obj is the model node, inputs is the pointer array of gridding
%  variables and the return value is a matrix with dimensions determined by
%  the cgvalue instances which the model takes as inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.4.3 $  $Date: 2004/02/09 08:24:24 $

list={'Model',@i_CalcModel;
    'Prediction error',@i_CalcPE};


%---------------------------------
function out=i_CalcModel(obj, vars)

if ~isa(obj,'cgmodelnode')
	error('Object is not a cgmodelnode');
end

model=getdata(obj);
if model.isSwitchExpr
    out = 'Cannot plot switching model';
else
    out = model.evaluategrid(vars);
end

%-------------------------------
function out=i_CalcPE(obj, vars)

inputs=getinputs(obj);
if ~isa(obj,'cgmodelnode')
	error('Object is not a cgmodelnode');
end

model=getdata(obj);
if model.isSwitchExpr
    out = 'Cannot plot prediction error for a switching model';
elseif pevcheck(model.info)
    out = model.evaluategrid(vars, 'pev');
else
    out='Prediction error is not defined for this model';
end
