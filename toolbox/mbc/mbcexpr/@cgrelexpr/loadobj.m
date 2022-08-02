function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:20 $ 

if isstruct(obj)
    % Pre version 2
    inp = null(xregpointer,1,2);
    if ~isempty(obj.left)
        inp(1) = obj.left;
    end
    if ~isempty(obj.right)
        inp(2) = obj.right;
    end 
    obj.cgexpr = setinputs(obj.cgexpr, inp);
    obj.version = 2;
    obj = rmfield(obj, 'left');
    obj = rmfield(obj, 'right');
end


if isstruct(obj)
    obj = cgrelexpr(obj);
end