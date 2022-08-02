function [mdev, lChanges, nameMap] = pUpdateToValidNames(mdev, nameMap);
%MDEVMLERF/PUPDATENAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $  $Date: 2004/04/04 03:31:21 $

% update model
mdev.Model = pUpdateToValidNames(mdev.Model, nameMap);

% update modeldev
mdev.modeldev = pUpdateToValidNames(mdev.modeldev, nameMap);

xregpointer(mdev);


