function [minInput, minOutput] = findextremum(obj, pVar, sType)
%FINDEXTREMUM Find minimum or maximum value of expression
%
%  [INVAL, EXPRVAL] = FINDEXTREMUM(OBJ, VAR, TYPE) finds the minimum of
%  maximum point of the expression OBJ along the dimension specified by the
%  variable pointer VAR.  TYPE specifies the extremum to search for:
%  'minimum' or 'maximum'.
%
%  All other input variables to OBJ that are not linked to VAR must be set
%  to scalar values.
%
%  The function outputs INVAL, the value of VAR that the extremum occurs
%  at, and EXPRVAL, the value of OBJ at that point.  VAR will be set to
%  INVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/04/04 03:27:23 $ 

% Check all other inputs are scalar
pInputs = getinports(obj);
pOther =pInputs(cgisindependentvars(pInputs, pVar));

bScalar = pveceval(pOther, 'isscalar');
if ~all([bScalar{:}])
    error('mbc:cgexpr:InvalidArgument', 'All other inputs to expression must be set to a scalar value.');
end

bType = strcmpi(sType, 'maximum');

% First evaluate 100 points across the dimension - quick way of finding a
% high region.  Then look in that region using fminbnd.
pVar.info = pVar.linspace(100);
dOutput = evaluate(obj);

if bType
    [dExtreme, nIndex] = max(dOutput);
else
    [dExtreme, nIndex] = min(dOutput);
end

lowIndex = max(1, nIndex-1);
highIndex = min(100, nIndex+1);
dValues = pVar.getvalue;
opts = optimset('Display', 'off', ...
    'MaxIter', 10, ...
    'TolX', diff(pVar.getrange)*1e-3);
[minInput, Y, OK] = fminbnd(@i_calc, dValues(lowIndex), dValues(highIndex), opts, obj, pVar, bType);

if OK<=0
    % Check that the solution is actually better than the original one we
    % found.
    if bType
        if (Y > -dValues(nIndex))
            minInput = dValues(nIndex);
        end
    else
        if (Y > dValues(nIndex))
            minInput = dValues(nIndex);
        end
    end
end

pVar.info = pVar.setvalue(minInput);
minOutput = evaluate(obj);



function Y = i_calc(X, obj, pVar, bType);
pVar.info = pVar.setvalue(X);
Y = i_eval(obj);
if bType
    Y = -Y;
end