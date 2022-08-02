function [obj, ss] = updateDefineTests(obj, ss)
%SWEEPSETFILTER/UPDATEDEFINETESTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:11:53 $

%   $Revision:

f = getFlags;

% Have we got a current copy of the sweepset
if nargin < 2 
    ss = ApplyObject(obj, [f.APPLY_DATA f.APPLY_VARS f.APPLY_FILT]);
end

% Update the current copy of the sweepset
ss = ApplyObject(obj, f.APPLY_TEST, ss);

% Now cascade the update to the tests
[obj, ss] = updateSweepFilters(obj, ss);
