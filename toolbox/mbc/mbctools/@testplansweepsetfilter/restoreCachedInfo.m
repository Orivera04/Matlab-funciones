function obj = restoreCachedInfo(obj)
%TESTPLANSWEEPSETFILTER/RESTORECACHEDINFO restore the cache prior to editing

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:12:37 $

% First cache the sweepsetfilter
obj = setCacheState(obj, true);
% Next update the testplan
obj = testplansweepsetfilter(obj, getTestplan(obj));
% Finally make sure the clusters are created
obj = runClusterAlgorithm(obj);
