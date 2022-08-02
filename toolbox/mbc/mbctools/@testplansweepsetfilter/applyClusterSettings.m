function obj = applyClusterSettings(obj)
% APPLYCLUSTERSETTINGS crystalises the cluster settings by turning them
% into excluded data and data nailed into the actual design
% Called when user finishes playing around and exits the dialog 
%
%  OBJ = APPLYCLUSTERSETTINGS(OBJ)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:11:12 $ 


% Get the mean data the clusters are derived from ans code accordingly
dblData = code(model(obj.codeddesign), obj.cachedInfo.meandata);
% Get the design - the pointer might be invalid
design = obj.codeddesign;

%% find indices of data to nail into the design
%% want to replace design points where possible
%% will do lone data as they live in a cluster
for i = 1:length(obj.clusters)
    thisCluster = obj.clusters(i);
    % Can this cluster be updated in the design
    if length(thisCluster.selecteddata) >= length(thisCluster.selecteddesign) & length(thisCluster.selecteddata) > 0
        % Modify the design
        design = dataIntoActualDesign(obj, design, dblData(thisCluster.selecteddata, :), thisCluster.selecteddesign);
    end
end
% Write the design back to the object
obj.codeddesign = design;
% Update the local cachedInfo
obj = updateCachedInfo(obj);
% Indicate that the actual design has changed
queueEvent(obj, 'tssfActualDesignChanged');
