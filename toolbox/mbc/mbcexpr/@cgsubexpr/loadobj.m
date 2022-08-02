function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:52 $ 

if isstruct(obj)
    % Pre-version 2.
    % Transfer pointers to parent class
    obj.cgexpr = setinputs(obj.cgexpr, [obj.left(:)', obj.right(:)']);
    obj.NLeft = length(obj.left);
    obj.NRight = length(obj.right);
    obj.version = 2;
    obj = rmfield(obj, 'left');
    obj = rmfield(obj, 'right');
end


if isstruct(obj)
    obj = cgsubexpr(obj);
end