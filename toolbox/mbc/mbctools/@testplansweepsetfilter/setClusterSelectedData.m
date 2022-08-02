function obj = setClusterSelectedData(obj, dataInds, clusterInd)
% SETCLUSTERSELECTEDDATA sets the selected data of the appropriate cluster
% to be GUIDS. Can supply the cluster index
%
%  OBJ = SETCLUSTERSELECTEDDATA(OBJ, DATAINDS)
%  OBJ = SETCLUSTERSELECTEDDATA(OBJ, DATAINDS, CLUSTERINDEX)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:40 $ 

% If we have a cluster index lets see if we can believe it
if nargin > 2 &&  all(ismember(dataInds, obj.clusters(clusterInd).data))
      obj = i_changeSelectedData(obj, dataInds, clusterInd);
   return
end

% Fallen through to here means we need to find the relevant cluster
% ourselves. Loop through them and stop when we find the GUIDS
for clusterInd = 1:length(obj.clusters)
   if all(ismember(dataInds, obj.clusters(clusterInd).data))
      obj = i_changeSelectedData(obj, dataInds, clusterInd);
      return
   end
end

warning('mbc:testplansweepsetfilter:InvalidArgument','Guids not found in any one cluster. No change made to selected data.');

%--------------------------------------------
%%   SUBFUNTION i_changeSelectedData
%--------------------------------------------
function obj = i_changeSelectedData(obj, dataInds, clusterInd)

thisCluster = obj.clusters(clusterInd);
% Has anything changed
if ~isequal(thisCluster.selecteddata, dataInds)
    % Set the selected data
    thisCluster.selecteddata = dataInds;
    % Update the cluster status
    thisCluster.status = getClusterStatus(thisCluster);
    % Write back to the clusters
    obj.clusters(clusterInd) = thisCluster;
    % Update the excluded data
    obj = modifyExcludedData(obj, setdiff(thisCluster.data, dataInds), dataInds);
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
