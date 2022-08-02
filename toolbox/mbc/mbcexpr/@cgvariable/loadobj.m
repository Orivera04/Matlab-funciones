function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 07:16:51 $ 

% Need to reconstitute a valid Value field.  Set it to the Nominal Value.
obj.Value = obj.NominalValue;

% Upgrade object from old versions
if obj.version < 2
    obj.BackupValue = {};
    obj.BackupGUIDs = guidarray;
    obj.version = 2;
end

if isstruct(obj)
    obj = cgvariable(obj);
end