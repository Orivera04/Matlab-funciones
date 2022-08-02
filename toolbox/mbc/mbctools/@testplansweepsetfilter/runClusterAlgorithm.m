function tssf = runClusterAlgorithm(tssf)
%TSSF = RUNCLUSTERALGORITHM(TSSF) runs the cluster algorithm and hence refreshes the
%cluster field of this obj
%
%  TSSF = RUNCLUSTERALGORITHM(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.2 $    $Date: 2004/02/09 08:12:38 $ 

%% Will need to run cluster alg only on those data that have not yet been
%% nailed into the design. Filter out the data (by GUID?) using a
%% combination of tssf.selectedData and flags in tssf.codeddesign

% Get some initial sizes
numDesignPoints = npoints(tssf.codeddesign);
numDataPoints   = size(tssf.cachedInfo.meandata, 1);

% Find all design points that are not in the data
designNotInDataIndices = setdiff(1:numDesignPoints, tssf.cachedInfo.designindata);
dataNotInDesignIndices = setdiff(1:numDataPoints, tssf.cachedInfo.dataindesign);
excludedIndices        = get(tssf, 'excludedDataInds');

design = tssf.cachedInfo.uncodeddesign(designNotInDataIndices, :);
data   = tssf.cachedInfo.meandata(dataNotInDesignIndices, :);

%% ======= do the clustering ==============
tol = get(tssf,'tolerances');
[dataInds, designInds] = feval(tssf.clusterAlg, design, data, tol);

% Ensure the output cell arrays are all 1 x N
if any(cellfun('size', [dataInds designInds], 1) ~= 1)
    error('mbc:testplansweepsetfilter:InvalidState', 'Cluster algorithm produced an invalid size output');
end

% Need to re-index the data and design indices from the cluster algorithm
% so they refer to all the data from the sweepsetfilter
for i = 1:length(dataInds)
    dataInds{i}   = dataNotInDesignIndices(dataInds{i});
    designInds{i} = designNotInDataIndices(designInds{i});
end

% Add the lone data and lone design as the last two clusters
dataInds{end+1} = setdiff(dataNotInDesignIndices, [dataInds{:}]);
designInds{end+1} = [];

dataInds{end+1} = [];
designInds{end+1} = setdiff(designNotInDataIndices, [designInds{:}]);

% Initialise the other cluster fields
selectedDataInds   = cell(size(dataInds));
selectedDesignInds = designInds;

% Set the selectedDesignInds
for i = 1:length(designInds)
    % Remove any excluded data from the selected data
    notExcluded = ~ismember(dataInds{i}, excludedIndices);
    % Define the selected data
    selectedDataInds{i} = dataInds{i}(notExcluded);
end

clusterStatus = getClusterStatus(dataInds, selectedDataInds, designInds, selectedDesignInds);

newClusters = struct(...
    'data',           dataInds,...
    'design',         designInds,...
    'status',         clusterStatus,...
    'selecteddata',   selectedDataInds,...
    'selecteddesign', selectedDesignInds);

tssf.clusters = newClusters;

%% see if the defaultSettings should be used to select/unselect data in the
%% clusters
if tssf.defaultSelection.apply
    tssf = applyDefaultSelection(tssf);
    %% if we do this we need to set the apply flag back to false
    tssf.defaultSelection.apply = false;
end


queueEvent(tssf, {'tssfClustersCreated' 'tssfClustersChanged'});
