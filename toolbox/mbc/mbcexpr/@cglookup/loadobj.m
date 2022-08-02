function obj = loadobj(obj)
%LOADOBJ Laod-time reconstruction of cglookup
%
%  OBJ = LOADOBJ(OBJ) is called during the loading of cglookup objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:25 $ 

if isstruct(obj)
    % Version 1 had no version field
    obj.sizelocks = guidarray(0);
    obj.version = 2;
end

if obj.version<3
    % Add new fields to support extrapolation procedures for all tables
    obj.ExtrapolationMask = true(0);
    obj.ExtrapolationRegions = true(0);
    obj.version = 3;
end


% If the object came in as a structure it needs to be turned back into a
% class by the constructor
if isstruct(obj)
    obj = cglookup(obj);
end