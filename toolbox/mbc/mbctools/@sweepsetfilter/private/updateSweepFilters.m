function [obj, ss] = updateSweepFilters(obj, ss, index)
%UPDATESWEEPFILTERS 
%
%  [OBJ, SS] = UPDATESWEEPFILTERS(OBJ, SS, INDEX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:32:05 $ 

f = getFlags;

% Have we got a current copy of the sweepset
if nargin < 2 || ~isa(ss, 'sweepset')
    ss = ApplyObject(obj, [f.APPLY_DATA f.APPLY_VARS f.APPLY_FILT f.APPLY_TEST]);
end

% Ensure that index is initialised
if nargin < 3
    index = 1:length(obj.sweepFilters);
end

% Store to see if filters are changed in the update process
INITIAL_sweepFilters = obj.sweepFilters;

% Logical vector indicating which sweeps to remove, none to start with
lSweepsToRemove = false(size(ss, 3), 1);

% Iterate through the sweep filters
for i = 1:length(obj.sweepFilters)
    % Do we need to re-evaluate this filter?
    if ismember(i, index)
        % Evaluate this filter
        obj.sweepFilters(i) = i_evaluateSweepFilter(obj.sweepFilters(i), ss);
    end
    % OR the filterResult with the previous removed sweeps
    lSweepsToRemove = lSweepsToRemove | obj.sweepFilters(i).filterResult;
end

% Which sweeps have been removed
obj.sweepsToRemove = find(lSweepsToRemove);

% Have the filters actually changed
if ~isidentical(obj.sweepFilters, INITIAL_sweepFilters)
    queueEvent(obj, 'ssfSweepFiltersChanged');
end

% Update the current copy of the sweepset
ss = ApplyObject(obj, f.APPLY_SFILT, ss);

% Now cascade the update to the tests
[obj, ss] = updateReorderSweeps(obj, ss);

%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
function filter = i_evaluateSweepFilter(filter, ss)

try
    % Evaluate the filter criteria using sweepset/sweepeval, true to keep data
    lKeepSweeps = sweepeval(ss, filter.inlineExp);
    % Ensure the returned logical array is the correct size
    if numel(lKeepSweeps) ~= size(ss, 3)
        error('mbc:sweepsetfilter:InvalidExpression', 'Returned array is incorrectly sized');
    end
    % Invert for removed sweeps
    lRemoveSweeps = logical(~lKeepSweeps);
    % Check that the logical array isn't larger than the number of sweeps
    if length(lRemoveSweeps) ~= size(ss, 3)
        error('mbc:sweepsetfilter:InvalidExpression', 'Expression returns an invalid vector');
    end
    % How many have been removed by this filter
    filter.result = sprintf('Filter successfully applied : %d tests excluded', sum(lRemoveSweeps));
    filter.OK = true;
    % Store the logical removed array efficiently
    filter.filterResult = mbcCompressLogicalArray(lRemoveSweeps);
catch
    % No sweeps filtered out by this filter
    filter.filterResult = sparse(false(size(ss, 3), 1));
    filter.OK = false;
    filter.result = ['Error : Ignoring filter definition ''' filter.filterExp ''': Invalid variable name or expression'];
end
