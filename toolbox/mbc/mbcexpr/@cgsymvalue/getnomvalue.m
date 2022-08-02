function val = getnomvalue(obj)
%GETNOMVALUE Return nominal value for object
%
%  OUT = GETNOMVALUE(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:30 $ 

InputVals = cell(size(obj.EquationInputs));
for n = 1:length(InputVals)
    InputVals{n} = getnomvalue(obj.EquationPointers(n).info);
end

val = pr_evalinline(obj.EquationObject, InputVals);