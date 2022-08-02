function obj = updaterange(obj)
%UPDATERANGE Attempt to find range from inputs
%
%  OBJ = UPDATERANGE(OBJ) evaluates the formula over a range of input
%  values and tries to find the minimum and maximum possible outputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:27:48 $ 

if ~isempty(obj.EquationString)
    pValue = obj.EquationPointers(obj.EquationVariableIndex);
    rng = pValue.getrange;
    
    definputs = cell(size(obj.EquationPointers));
    for n = 1:length(definputs)
        definputs{n} = obj.EquationPointers(n).getnomvalue;
    end
    [x, Rmin, minok] = fminbnd(@i_minimiser, rng(1), rng(2), optimset('fminbnd'), ...
        obj.EquationObject, ...
        definputs, ...
        obj.EquationVariableIndex);
    [x, Rmax, maxok] = fminbnd(@i_maximiser, rng(1), rng(2), optimset('fminbnd'), ...
        obj.EquationObject, ...
        definputs, ...
        obj.EquationVariableIndex);
    if minok>0 && maxok>0
        obj = setrange(obj, [Rmin, -Rmax]);
    end
end



function val = i_minimiser(x, il, allParam, xind)
allParam{xind} = x;
val = il(allParam{:});

function val = i_maximiser(x, il, allParam, xind)
allParam{xind} = x;
val = -il(allParam{:});