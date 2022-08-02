function obj = setClusterSelectedDesign(obj, designInds, clusterInd)
% SETCLUSTERSELECTEDDESIGN sets the selected design of the appropriate cluster
% to be GUIDS. Can supply the cluster index
%
%  OBJ = SETCLUSTERSELECTEDDESIGN(OBJ, DESIGNINDS)
%  OBJ = SETCLUSTERSELECTEDDESIGN(OBJ, DESIGNINDS, CLUSTERINDEX)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:41 $ 

% If we have a cluster index lets see if we can believe it
if nargin > 2 &&  all(ismember(designInds, obj.clusters(clusterInd).design))
      obj = i_changeSelectedDesign(obj, designInds, clusterInd);
   return
end

% Fallen through to here means we need to find the relevant cluster
% ourselves. Loop through them and stop when we find the designInds
for clusterInd = 1:length(obj.clusters)
   if all(ismember(designInds, obj.clusters(clusterInd).design))
      obj = i_changeSelectedDesign(obj, designInds, clusterInd);
      return
   end
end

warning('InvalidArgument','Design indices not found in any one cluster. No change made to selected design points.');



%--------------------------------------------
%   SUBFUNTION i_changeSelectedDesign
%--------------------------------------------
function obj = i_changeSelectedDesign(obj, designInds, clusterInd)

thisCluster = obj.clusters(clusterInd);
% Has anything changed
if ~isequal(thisCluster.selecteddesign, designInds)
    % Set the selected data
    thisCluster.selecteddesign = designInds;
    % Update the cluster status
    thisCluster.status = getClusterStatus(thisCluster);
    % Write back to the clusters
    obj.clusters(clusterInd) = thisCluster;
    % Tell everyone that the cluster has changed
    queueEvent(obj, 'tssfClustersChanged');
end

% YOU CAN'T HAVE GUI CODE IN A DATA MODEL OBJECT - THIS IS BAD!
% if length(obj.clusters(clusterInd).selecteddata) < length(obj.clusters(clusterInd).selecteddesign)
%    %% now have too few data points to replace the design points currently
%    %% selected
%    warndlg(['You now have too few data points to replace all of the design points selected in this ',...
%          'cluster. Only the first ' num2str(length(obj.clusters(clusterInd).selecteddata)),...
%          ' design points will be replaced.'],'Data Selection Warning');
% end
