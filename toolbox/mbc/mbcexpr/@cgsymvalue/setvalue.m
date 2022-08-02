function [VariablePtr, OK, msg] = setvalue(obj, val, nulptr)
% CGSYMVALUE/SETVALUE Set the value of a symbolic value object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:16:02 $

OK=1;
msg='';

InputVals = cell(size(obj.EquationInputs));
InputArgs = argnames(obj.InverseObject);
myname = getname(obj);
for n = 1:length(InputVals)
    if strcmp(InputArgs{n}, myname)
        InputVals{n} = val;
    else
        ptr = obj.EquationPointers(strcmp(InputArgs{n}, obj.EquationInputs));
        InputVals{n} = getvalue(ptr.info);
        if length(InputVals{n})>1
            InputVals{n} = getnomvalue(ptr.info);
        end
    end
end
VariableVal = pr_evalinline(obj.InverseObject, InputVals);
VariablePtr = obj.EquationPointers(obj.EquationVariableIndex);
VariablePtr.info  = setvalue(VariablePtr.info, VariableVal);

if nargin==2
    VariablePtr = obj;
end