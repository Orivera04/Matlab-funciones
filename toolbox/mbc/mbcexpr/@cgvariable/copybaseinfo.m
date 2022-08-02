function obj2 = copybaseinfo(obj1, obj2)
%COPYBASEINFO Copy base-class information from one object to another
%
%  DEST = COPYBASEINFO(SRC, DEST), where SRC and DEST are both inputexpr
%  objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.3 $    $Date: 2004/02/09 07:16:30 $ 


% Copy name
obj2 = setname(obj2, getname(obj1));

% Copy this object's fields.
fields = {'Description', 'Alias', 'BackupValue', 'BackupGUIDs'};

for k = 1:length(fields)
    obj2.(fields{k}) = obj1.(fields{k});
end

% Use method calls for NominalValue and Value as formulas (cgsymvalue) 
% calulate these rather than hold them in the fields.
obj2.NominalValue = getnomvalue( obj1 );
obj2.Value = getvalue( obj1 );
