function pVar = getvariable(obj)
%GETVARIABLE Return pointer to symvalue's input variable
%
%  PVAR = GETVARIABLE(OBJ) returns the pointer to the formula's input that
%  is considered to be the "variable".

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:34 $ 

if ~isempty(obj.EquationPointers)
    pVar = obj.EquationPointers(obj.EquationVariableIndex);
end