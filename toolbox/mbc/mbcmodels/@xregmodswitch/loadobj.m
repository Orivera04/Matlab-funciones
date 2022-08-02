function obj = loadobj(obj)
%LOADOBJ Load-time updating
%
%  OBJ = LOADOBJ(OBJ) updates an object during loading to ensure it is the
%  latest version.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:48 $ 

if obj.Version<2
    % Add ability to have tolerance per factor
    obj.Tolerance = repmat(1e-3, 1, size(obj.OpPoints,2));
    obj.Version = 2;
end

if isstruct(obj)
    obj = xregmodswitch(obj);
end
