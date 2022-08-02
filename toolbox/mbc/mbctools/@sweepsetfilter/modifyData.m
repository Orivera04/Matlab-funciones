function [obj] = modifyData(obj, rows, cols, data)
%MODIFYDATA A short description of the function
%
%  OBJ = MODIFYDATA(OBJ, ROWS, COLS, DATA)
%  
% This function modifies the data in the rows and cols of the underlying 
% sweepset with the specified data. 
%
% ROWS can be either an index into the underlying sweepset or a guid array
% COLS can be either an index into the underlying sweepset of a cell array of string
% DATA should be a matrix of size length(ROWS) x length(COLS) or empty. If DATA
%  is empty then any modifications made in ROWS and COLS will be removed

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:31:59 $ 

% Get the underlying sweepset and it's variable names and guids
ss = obj.pSweepset.sweepset;

% Convert S1 and S2 to guids and variable names
ssVars = get(ss, 'name');
% Convert numeric index to cell array of strings
if isnumeric(cols)
    cols = ssVars(cols);
else
    % Ensure that S2 is a cell array
    if ~iscell(cols)
        cols = {cols};
    end
    % Ensure that this cell array is horizontal
    cols = reshape(cols, 1, numel(cols));
    % Check we can find all the requested variables in the sweepset
    ALL_FOUND = all(ismember(cols, ssVars));
    if ~ALL_FOUND
        error('mbc:sweepsetfilter:InvalidArgument', 'Variables not found in sweepsetfilter');
    end
end

if isnumeric(rows)
    ssGuid = getGuids(ss);
    rows = ssGuid(rows);
elseif isa(rows, 'guidarray')
    % Do nothing - this is OK
else
        error('mbc:sweepsetfilter:InvalidArgument', 'Invalid specification for the rows to change');    
end

% At this point - cols is a cell array of strings and rows is a
% guidarray. Both uniquely identify the records and columns being
% assigned to.

md = obj.modifiedData;

% Grow the dataValues matrix by the unfound params
unfoundGuidIndex = find(~ismember(rows, md.rowGuid));
unfoundVarsIndex = find(~ismember(cols, md.columnName));
rowsToAdd = [1:length(unfoundGuidIndex)] + size(md.dataValues, 1);
colsToAdd = [1:length(unfoundVarsIndex)] + size(md.dataValues, 2);
md.dataValues(rowsToAdd, colsToAdd)   = 0;
md.dataPosition(rowsToAdd, colsToAdd) = false;

% Add the new guids and vars to the matrix headers
md.rowGuid = [md.rowGuid; rows(unfoundGuidIndex)];
md.columnName = [md.columnName cols(unfoundVarsIndex)];

% Now all guids and variables should exist
guidIndex = md.rowGuid(rows);
varsIndex = i_findStringsInList(cols, md.columnName);

% Add the data - note special case for empty data indicating that
% the changes made are to be removed
if isempty(data)
    md.dataValues(guidIndex, varsIndex) = 0;
    md.dataPosition(guidIndex, varsIndex) = false;
else
    md.dataValues(guidIndex, varsIndex) = data;
    md.dataPosition(guidIndex, varsIndex) = true;
end

% Has the field actually changed
if ~isidentical(md, obj.modifiedData)
    % Let's just send the ssfBadDataChanged event as there is no easy way to decide
    % if it has actually changed or not - likelyhood is that listeners are collapsing
    % this onto ssDataChanged as well.
    queueEvent(obj, {'ssfModifyDataChanged' 'ssfBadDataChanged'});
end

% Update the contents of the modifiedData field
obj.modifiedData = md;

% Now update the orders of the rows and columns to reflect the
% contents of the sweepset so that appending is fast
obj = updateModifiedData(obj);

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
