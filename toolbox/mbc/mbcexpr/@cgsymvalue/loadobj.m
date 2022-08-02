function obj = loadobj(obj)
%LOADOBJ Load-time fixing for object
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:15:38 $ 

if isstruct(obj)
    if ~isfield(obj, 'version')
        % Pre-version 2 updates
        % This update path requires the Variable Dictionary to execute a
        % post-load operation to successfully transfer the equation
        % information into this object
        oldobj = obj;
        obj = struct('EquationString', oldobj.eqindex, ...
            'EquationPointers', assign(xregpointer, []),...
            'EquationInputs', {{}}, ...
            'EquationVariableIndex', 0, ...
            'EquationObject', [], ...
            'InverseObject', [], ...
            'version', 2, ...
            'cgvalue', oldobj.cgvalue);
    end
    
    obj = cgsymvalue(obj);
end