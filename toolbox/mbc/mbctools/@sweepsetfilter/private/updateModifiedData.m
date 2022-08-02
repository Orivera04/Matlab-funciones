function [obj, ss] = updateModifiedData(obj, ss);
%SWEEPSETFILTER/UPDATEMODIFIEDDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.3 $ 

% Have we been passed a sweepset as second argument
if nargin < 2
    ss = obj.pSweepset.info;
end

f = getFlags;

% Get the variables and guids from the sweepset
ssVars = get(ss, 'name');
ssGuid = getGuids(ss);

% Get the modifiedData structure from the object
md = obj.modifiedData;

% Store to see if it is changed in the update process
INITIAL_md = md;

% Need to reorder the dataValues and dataPosition matricies to reflect the
% actual order of guids and variables in the sweepset ss

% Which guids and vars are actually present in the sweepset
foundGuidIndex = ssGuid(md.rowGuid);
foundVarsIndex = i_findStringsInList(md.columnName, ssVars);

% Force unfound vars and guids indidices to NaN and hence the right when
% sorted
foundGuidIndex(foundGuidIndex == 0) = NaN;
foundVarsIndex(foundVarsIndex == 0) = NaN;
% Sort the indicies into the order found in the sweepset
[sortGuidIndex, reindexGuid] = sort(foundGuidIndex);
[sortVarsIndex, reindexVars] = sort(foundVarsIndex);

% Reindex the data, guids, columns and position
md.dataValues = md.dataValues(reindexGuid, reindexVars);
% Seems to be a dispatching bug with sparse logical arrays so
dataPos = sparse(logical(md.dataPosition(reindexGuid, reindexVars)));
md.dataPosition = dataPos;
md.rowGuid = md.rowGuid(reindexGuid);
md.columnName = md.columnName(reindexVars);


% Update the valid rows and cols entries
md.validRows = sum(isfinite(foundGuidIndex));
md.validCols = sum(isfinite(foundVarsIndex));

% Finally recreate the full position matrix
md.fullPosition = sparse(false(length(ssGuid), length(ssVars)));
md.fullPosition(sortGuidIndex(1:md.validRows), sortVarsIndex(1:md.validCols)) = ...
    md.dataPosition(1:md.validRows, 1:md.validCols);

% Put the modified struct back into the object
obj.modifiedData = md;

% Has the field actually changed
if ~isidentical(md, INITIAL_md)
    % Let's just send the ssfBadDataChanged event as there is no easy way to decide
    % if it has actually changed or not - likelyhood is that listeners are collapsing
    % this onto ssDataChanged as well.
    queueEvent(obj, {'ssfModifyDataChanged' 'ssfBadDataChanged'});
end

% Update the sweepset passed out by calling apply object and only asking
% for the APPLY_DATA part
ss = ApplyObject(obj, f.APPLY_DATA, ss);

% Now cascade the update to the filters
[obj, ss] = updatevariable(obj, ss);

% --------------------------------------------------------------------
% 
% --------------------------------------------------------------------
function index = i_findStringsInList(S, L)

index = zeros(size(S));
for i = 1:numel(S)
    j = find(strcmp(S{i}, L));
    if ~isempty(j)
        index(i) = j(1);
    end
end
