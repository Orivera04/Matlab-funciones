function [obj, ss] = updateFilter(obj, ss, index)
%UPDATEFILTER
%
%  Function to update the sweepsetfilter cached filter fields

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:32:03 $

f = getFlags;

% Have we got a current copy of the sweepset
if nargin < 2 || ~isa(ss, 'sweepset')
    ss = ApplyObject(obj, [f.APPLY_DATA, f.APPLY_VARS]);
end

% Ensure that index is initialised
if nargin < 3
    index = 1:length(obj.filters);
end

% Store to see if filters are changed in the update process
INITIAL_filters = obj.filters;

% Logical vector indicating which records to remove, none to start with
lRecordsToRemove = false(size(ss, 1), 1);

% Iterate through the filters
for i = 1:length(obj.filters)
    % Do we need to re-evaluate this filter?
    if ismember(i, index)
        % Evaluate this filter
        obj.filters(i) = i_evaluateFilter(obj.filters(i), ss);
    end
    % OR the filterResult with the previous removed records
    lRecordsToRemove = lRecordsToRemove | obj.filters(i).filterResult;
end

% Which guids have been removed?
lRecordsToRemove = lRecordsToRemove | ismember(getGuids(ss), obj.filterGuid);

% Record oldRecordsToRemove to see if we think we should fire ssfBadDataChanged
oldRecordsToRemove = obj.recordsToRemove;

% Which records have been removed
obj.recordsToRemove = find(lRecordsToRemove);

% Have the filters actually changed
if ~isidentical(obj.filters, INITIAL_filters)
    queueEvent(obj, 'ssfFiltersChanged');
end
% Should fire ssfBadDataChanged
if ~isequal(obj.recordsToRemove, oldRecordsToRemove)
    queueEvent(obj, 'ssfBadDataChanged');
end

% Update the current copy of the sweepset
ss = ApplyObject(obj, f.APPLY_FILT, ss);

% Now cascade the update to the tests
[obj, ss] = updateDefineTests(obj, ss);

%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
function filter = i_evaluateFilter(filter, ss)

try
    % Evaluate the filter criteria using sweepset/seval, true to keep data
    lKeepRecords = seval(ss, filter.inlineExp);
    % Ensure the returned logical array is the correct size
    if numel(lKeepRecords) ~= size(ss, 1)
        error('mbc:sweepsetfilter:InvalidExpression', 'Returned array is incorrectly sized');
    end
    % Invert for removed records
    lRemoveRecords = logical(~lKeepRecords);
    % How many have been removed by this filter
    filter.result = sprintf('Filter successfully applied : %d records excluded', sum(lRemoveRecords));
    filter.OK = true;
    % Store the logical removed array efficiently
    filter.filterResult = mbcCompressLogicalArray(lRemoveRecords);
catch
    % No records filtered out by this filter
    filter.filterResult = sparse(false(size(ss, 1), 1));
    filter.OK = false;
    filter.result = ['Error : Ignoring filter definition ''' filter.filterExp ''': Invalid variable name or expression'];
end
