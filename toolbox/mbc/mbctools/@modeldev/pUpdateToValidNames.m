function [mdev, lChanged, nameMap] = pUpdateToValidNames(mdev, nameMap);
%MODELDEV/PUPDATETOVALIDNAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $  $Date: 2004/04/04 03:31:55 $

% NOTE - varargin may contain extra nameMaps for use by the model name conversion

% Update model with the new nameMap
mdev.Model = pUpdateToValidNames(mdev.Model, nameMap);

if isstruct(mdev.Y)
    % Data held as old stype structure with pointer and index
    mdev.Y.index = pUpdateToValidNames(mdev.Y.index, nameMap);
else
    % Data held as sweepsetfilter
    mdev.Y = pUpdateToValidNames(mdev.Y, nameMap);
end
    
if isstruct(mdev.X)
    % Data held as old stype structure with pointer and index
    mdev.X.index = pUpdateToValidNames(mdev.X.index, nameMap);
else
    % Data held as sweepsetfilter
    mdev.X.info = pUpdateToValidNames(mdev.X.info, nameMap);
end

% Update the modeldev pointer
xregpointer(mdev);

% Did anything change
lChanged = false;

