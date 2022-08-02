function array = getSweepGuids(obj, sweepIndex, level)
%SWEEPSET/GETSWEEPGUIDS returns the sweeps GUIDARRAY from a sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.2 $ 

if nargin < 2
    sweepIndex = ':';
end

% Are we including any bad records in the output array?
REMOVE_BAD_DATA = ischar(sweepIndex) && ~isempty(strmatch(lower(sweepIndex), 'goodonly'));

if nargin < 3
    level = 1;
end

% Get the sweep sizes matrix
sweepSizes = tsizes(obj, level);
% Do we need to reduce the size of the guidarray
if isnumeric(sweepIndex)
    % Get the record indicies of the requested sweep indicies
    recordIndex = RecPos(obj, sweepIndex);
    % Re-index the guidarray
    obj.guid = obj.guid(recordIndex);
    % Re-index the sweep sizes
    sweepSizes = sweepSizes(sweepIndex);
elseif REMOVE_BAD_DATA
    % Get the records with problems
    lBadRecords = any(isnan(obj.data), 2);
    % Get the xregdataset associated with the bad data
    [badDataset, lBadSweepIndex] = sweeppos(obj.xregdataset, lBadRecords);
    badSweepSizes = tsizes(badDataset);
    % Remove the correct numbers from the sizes matrix
    sweepSizes(lBadSweepIndex) = sweepSizes(lBadSweepIndex) - badSweepSizes;
    % Remove bad records from the guid array
    obj.guid = obj.guid(~lBadRecords);
end

if isempty(sweepSizes)
    % Check for no defined sweeps
    array = guidarray;
else
    % Produce the combined array from the guidarray
    array = getGroupArray(obj.guid, sweepSizes);
end
