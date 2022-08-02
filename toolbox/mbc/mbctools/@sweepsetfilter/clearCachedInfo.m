function obj = clearCachedInfo(obj)
%CLEARCACHEDINFO clear cached info for sweepsetfilter
%
%  OBJ = CLEARCACHEDINFO(OBJ)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:08:39 $ 

% Remove everything that isn't needed for computing the sweepsetfilter
obj.allowsCacheing = false;
obj.cachedSweepset = [];

% Could go through and remove the results from the filters and notes