function [ssf] = updateCache(ssf)
%UPDATECACHE private function to update the cache state of the sweepsetfilter
%
%  SSF = UPDATECACHE(SSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:30 $ 

% Set the cache to be empty
ssf.cachedSweepset = [];
% Does the ssf need a cache at all?
if ssf.allowsCacheing
    ssf.cachedSweepset = ApplyObject(ssf);
end
