function pVar = getconstants(obj)
%GETCONSTANTS Return pointer to symvalue's input constants
%
%  PVAR = GETVARIABLE(OBJ) returns the pointer to the formula's inputs that
%  are considered to be constants.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:27 $ 

if ~isempty(obj.EquationPointers)
    pVar = obj.EquationPointers;
    pVar(obj.EquationVariableIndex) = [];
end
