function obj = subsasgn(obj, S, data)
%SWEEPSETFILTER/SUBSASGN subsasigning of SWEEPSETFILTER objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $ 

% Switch on the subsasgn first type
switch S(1).type
    case '()'
        % Get the contents of the first and second brackets
        S1 = S(1).subs{1};
        S2 = S(1).subs{2};
        
        % Get the underlying sweepset and it's variable names and guids
        ss = sweepset(obj);

        % Convert S1 and S2 to guids and variable names
        ssVars = get(ss, 'name');
        ssGuid = getGuids(ss);
        % Convert numeric index to cell array of strings
        if isnumeric(S2)
            S2 = ssVars(S2);
        else
            % Ensure that S2 is a cell array
            if ~iscell(S2)
                S2 = {S2};
            end
            % Check we can find all the requested variables in the sweepset
            ALL_FOUND = all(ismember(S2, ssVars));
            if ~ALL_FOUND
                error('mbc:sweepsetfilter:InvalidArgument', 'Variables not found in sweepsetfilter');
            end
        end
        % TODO - S1 could already be a guid
        S1 = ssGuid(S1);
        
        % At this point - S2 is a cell array of strings and S1 is a
        % guidarray. Both uniquely identify the records and columns being
        % assigned to.
        
        md = obj.modifiedData;
               
        % Grow the dataValues matrix by the unfound params
        unfoundGuidIndex = find(~ismember(S1, md.rowGuid));
        unfoundVarsIndex = find(~ismember(S2, md.columnName));
        rowsToAdd = [1:length(unfoundGuidIndex)] + size(md.dataValues, 1);
        colsToAdd = [1:length(unfoundVarsIndex)] + size(md.dataValues, 2);
        md.dataValues(rowsToAdd, colsToAdd)   = 0;
        md.dataPosition(rowsToAdd, colsToAdd) = false;
        
        % Add the new guids and vars to the matrix headers
        md.rowGuid = [md.rowGuid; S1(unfoundGuidIndex)];
        md.columnName = [md.columnName S2(unfoundVarsIndex)];
        
        % Now all guids and variables should exist
        guidIndex = md.rowGuid(S1);
        varsIndex = i_findStringsInList(S2, md.columnName);
        
        % Add the data
        md.dataValues(guidIndex, varsIndex) = data;
        md.dataPosition(guidIndex, varsIndex) = true;
        
        % Update the contents of the modifiedData field
        obj.modifiedData = md;
        
        % Now update the orders of the rows and columns to reflect the
        % contents of the sweepset so that appending is fast
        obj = updateModifiedData(obj);
        
    otherwise
        error('mbc:sweepsetfilter:InvalidArgument', 'Invalid assignment scheme');
end

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
