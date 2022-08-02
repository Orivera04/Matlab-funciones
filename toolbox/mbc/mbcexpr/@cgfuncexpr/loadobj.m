function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:11:03 $ 

if isstruct(obj)
    % Pre version 2
    obj.cgexpr = setinputs(obj.cgexpr, obj.list);
    obj.version = 2;
    obj = rmfield(obj, 'list');
    obj = rmfield(obj, 'units');
end


if isstruct(obj)
    obj = cgfuncexpr(obj);
end