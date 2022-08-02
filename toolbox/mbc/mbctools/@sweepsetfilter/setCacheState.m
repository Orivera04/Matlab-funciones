function [obj] = setCacheState(obj, cacheState)
%SETCACHESTATE A short description of the function
%
%  OUT = SETCACHESTATE(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:15 $ 

% Deal with a string state first
if ischar(cacheState)
    cacheState = strcmp(cacheState, 'on');
end

if (isnumeric(cacheState) || islogical(cacheState)) && numel(cacheState) == 1
    % Update the internal flag
    obj.allowsCacheing = logical(cacheState);
    % And update the object
    obj = updateCache(obj);
else
    error('mbc:sweepsetfilter:InvalidArgument', 'Cache state must be a 1x1 numeric value');
end
