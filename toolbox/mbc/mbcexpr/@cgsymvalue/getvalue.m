function val = getvalue(obj)
%GETVALUE Return value of object
%
%  VAL = GETVALUE(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:33 $ 

InputVals = cell(size(obj.EquationInputs));
for n = 1:length(InputVals)
    InputVals{n} = getvalue(obj.EquationPointers(n).info);
    if (n~=obj.EquationVariableIndex) && (length(InputVals{n})>1)
        InputVals{n} = getnomvalue(obj.EquationPointers(n).info);
    end
end

val = pr_evalinline(obj.EquationObject, InputVals);