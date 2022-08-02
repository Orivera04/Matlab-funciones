function [turnInput, turnOutput, conv] = findturning(obj, pVar)
%FINDTURNING Find turning point of expression
%
%  [INVAL, EXPRVAL, OK] = FINDTURNING(OBJ, VAR) finds the nearest turning point
%  of the expression OBJ along the dimension specified by the variable
%  pointer VAR.
%
%  All other input variables to OBJ that are not linked to VAR must be set
%  to scalar values.
%
%  The function outputs INVAL, the value of VAR that the turning point
%  occurs at, and EXPRVAL, the value of OBJ at that point.  VAR will be set
%  to INVAL.  If a turning point is not found, OK is set to false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:08:37 $ 

pInputs = getinports(obj);
bScalar = pveceval(pInputs, 'isscalar');
if ~all([bScalar{:}])
    error('mbc:cgexpr:InvalidArgument', 'All inputs to expression must be set to a scalar value.');
end

MaxIter = 30;
Delta = 1e-5;
Tol = 1e-4;
conv = false;

startVal = pVar.getvalue;
for i = 1:MaxIter
    dff = i_EvalDiff(obj,pVar);
    if abs(dff) < Tol
        conv = true;
        break
    else
        dHere = pVar.getvalue;
        pVar.info = pVar.setvalue(dHere+Delta);
        newdff = i_EvalDiff(obj, pVar);
        pVar.info = pVar.setvalue(dHere - (Delta .* dff ./ (newdff - dff)));
    end
end

if ~conv
    turnInput = startVal;
else
    rng = pVar.getrange;
    turnInput = pVar.getvalue;
    if ~(turnInput>=rng(1) && turnInput<=rng(2))
        conv = false;
        turnInput = startVal;
    end
end

pVar.info = pVar.setvalue(turnInput);
turnOutput = i_eval(obj);



%-----------------------------------------------------------
function out = i_EvalDiff(obj, pVar)
%-----------------------------------------------------------
Delta = 1e-3;
dHere = pVar.getvalue;
pVar.info = pVar.setvalue([dHere dHere+Delta]);
out = diff(i_eval(obj)) ./ Delta;
pVar.info = pVar.setvalue(dHere);