function obj = setnomvalue(obj, val)
%SETNOMVALUE Set nominal value of object
%
%  OBJ = SETNOMVALUE(OBJ, VAL)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:01 $ 

InputVals = cell(size(obj.EquationInputs));
InputArgs = argnames(obj.InverseObject);
myname = getname(obj);
for n = 1:length(InputVals)
    if strcmp(InputArgs{n}, myname)
        InputVals{n} = val;
    else
        ptr = obj.EquationPointers(strcmp(InputArgs{n}, obj.EquationInputs));
        InputVals{n} = getnomvalue(ptr.info);
    end
end
VariableVal = pr_evalinline(obj.InverseObject, InputVals);
VariablePtr = obj.EquationPointers(obj.EquationVariableIndex);
VariablePtr.info  = setnomvalue(VariablePtr.info, VariableVal);