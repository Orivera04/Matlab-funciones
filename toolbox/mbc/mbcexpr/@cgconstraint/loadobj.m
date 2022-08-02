function obj = loadobj(obj)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:09:24 $ 


if obj.version<2
    % a few objects have version==1, but have been upgraded to version==2
    if isfield( obj, 'facptrs')
        obj.cgexpr = setinputs(obj.cgexpr, obj.facptrs);
        obj = rmfield(obj, 'facptrs');
    end
    obj.version = 2;
end

if isstruct(obj)
    obj = cgconstraint(obj);
end
