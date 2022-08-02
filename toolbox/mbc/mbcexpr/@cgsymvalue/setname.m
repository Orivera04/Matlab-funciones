function obj = setname(obj, newname)
%SETNAME Set a new name for object
%
%  OBJ = SETNAME(OBJ, NEWNAME)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 07:16:00 $ 

% Need to update the inverse object to use the correct name
if ~isempty(obj.EquationString)
    obj.InverseObject = createinverse(newname, obj.EquationString, obj.EquationInputs{obj.EquationVariableIndex});
end
obj.cgvalue = setname(obj.cgvalue, newname);
