function [out, indexMap, ss] = sweepsetWithBadData(obj)
%TESTPLANSWEEPSETFILTER/SWEEPSETWITHBADDATA
%
% out = sweepsetWithBadData(obj)
%
% returns a sweepset that allows the user to see which records and tests
% were removed from the underlying sweepset. There is a distinct similarity
% between sweepset(obj) and sweepsetWithBadData(obj)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:12:45 $

% First call it on my sweepsetfilter
[out, indexMap, ss] = sweepsetWithBadData(obj.sweepsetfilter);
% Next which guids have I removed
index = find(ismember(obj.excludedData, getSweepGuids(ss)));
% Set the applicable bits to NaN
out(:, :, index) = NaN;
% Remove the same sweeps from indexMap and ss
indexMap(index) = [];
% Call applyobject on the sweepset
ss = ApplyObject(obj, ss);
