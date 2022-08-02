function obj = clearCachedInfo(obj)
%CLEARCACHEDINFO clear cached info for testplansweepsetfilter
%
%  OBJ = CLEARCACHEDINFO(OBJ)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:11:15 $ 

% Empty the sweepsetfilter cache
obj.sweepsetfilter = clearCachedInfo(obj.sweepsetfilter);
% Empty the local cache
obj = emptyClusterInfoCache(obj);
