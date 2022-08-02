function [obj, ss] = updateClusters(obj, ss)
%UPDATECLUSTERS A short description of the function
%
%  OUT = UPDATECLUSTERS(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:12:34 $ 

% No sweepset in so we need to get the data in
if nargin < 2
    ss = sweepset(sweepsetfilter(obj));
end

% Update the cache
obj = updateCachedInfo(obj);

% Run the cluster algorithm
obj = runClusterAlgorithm(obj);

% Propogate to the excluded data
[obj, ss] = updateExcludedData(obj, ss);
