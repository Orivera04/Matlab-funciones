function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:42 $ 

if isstruct(obj)
    % Pre-version 2.
    % Transfer pointers to parent class
    obj.cgexpr = setinputs(obj.cgexpr, [obj.top(:)', obj.bottom(:)']);
    obj.NTop = length(obj.top);
    obj.NBottom = length(obj.bottom);
    obj.version = 2;
    obj = rmfield(obj, 'top');
    obj = rmfield(obj, 'bottom');
end


if isstruct(obj)
    obj = cgdivexpr(obj);
end