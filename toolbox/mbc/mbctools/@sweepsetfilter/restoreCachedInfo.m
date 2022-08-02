function obj = restoreCachedInfo(obj)
%SWEEPSETFILTER/RESTORECACHEDINFO restore the cache prior to editing

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:12:11 $

obj = setCacheState(obj, true);