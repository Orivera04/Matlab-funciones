function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:13:36 $ 

if isstruct(obj)
    % Pre version 2
    if isempty(obj.input)
        obj.cgexpr = setinputs(obj.cgexpr, [null(xregpointer,1,1), obj.list(:)']);
    else
        obj.cgexpr = setinputs(obj.cgexpr, [obj.input, obj.list(:)']);
    end
    obj.version = 2;
    obj = rmfield(obj, 'input');
    obj = rmfield(obj, 'list');
end


if isstruct(obj)
    obj = cgmswitchexpr(obj);
end