function [obj, ss] = updateExcludedData(obj, ss)
%UPDATEEXCLUDEDDATA A short description of the function
%
%  OUT = UPDATEEXCLUDEDDATA(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:35 $ 

% No sweepset in so we need to get the data in
if nargin < 2
    ss = sweepset(sweepsetfilter(obj));
end

% Apply the sweep reorder change
ss = ApplyObject(obj, ss);

% Now ensure that everyone knows the tssf has changed - if we are
% an tssf this will update the cache, else it is upto derived classes to
% ensure that they make their changes and call the pUpdateSweepsetCache
% method
[obj, ss] = pTestplanSweepsetfilterChanged(obj, ss);

