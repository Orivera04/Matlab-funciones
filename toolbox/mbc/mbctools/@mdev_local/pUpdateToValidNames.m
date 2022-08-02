function [mdev, lChanged, nameMap] = pUpdateToValidNames(mdev, nameMap);
%MDEV_LOCAL/PUPDATETOVALIDNAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.3 $  $Date: 2004/04/04 03:31:16 $


global DEBUG_MBC_NAMEMAPS;
% Update two-stage models
for i = 1:length(mdev.TwoStage)
    mdev.TwoStage{i} = pUpdateToValidNames(mdev.TwoStage{i}, nameMap);
end
% Update the MLE models
if length(mdev.TwoStage) == 2
    mdev.MLE.Model = mdev.TwoStage{2};
end

% update modeldev
mdev.modeldev = pUpdateToValidNames(mdev.modeldev, nameMap);
xregpointer(mdev);

% update response feature sweepset - this has a different name map to that
% of the local node since no information about Testplan channel names is 
% propogated down to the lower global nodes
[mdev.RFData.info, lRFDataChanged, RFNameMap] = pUpdateToValidNames(mdev.RFData.info);

if ~isempty(DEBUG_MBC_NAMEMAPS)
    RFNameMap
else
    clear('global', 'DEBUG_MBC_NAMEMAPS');
end

% Update all children
children(mdev, @preorder, @pUpdateToValidNames, RFNameMap);

lChanged = false;



