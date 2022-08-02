function obj = loadobj(objIn);
% SWEEPSETFILTER/LOADOBJ load sweepsetfilter object and version control
%
%  Not Required yet

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.2 $  $Date: 2004/02/09 08:09:04 $



% Enter current version number of object
CurrentVersion = 2;

obj = objIn;

% Enter code for updating object in this case statement
switch obj.version
case 1
    obj = i_V1toV2(obj);
    obj = i_V2toV3(obj);
case 2
    obj = i_V2toV3(obj);
case 3
    % This is the current version number
otherwise
   warning(sprintf('%s contains an unknown sweepset version (%3.1f)',inputname(1),obj.version));
   % Need to return since a call to class on an invalid object would be bad
   return
end

% Might need to recreate the actual object class
if isstruct(obj)
    % Recreate the class
    obj = sweepsetfilter(obj);
end


% --------------------------------------------------------------------
% Convert version 1 sweepsetfilters to version 2
% --------------------------------------------------------------------
function obj = i_V1toV2(obj)
obj.version = 2;
% Rename sweepsetToAppend to variableSweepset
obj.variableSweepset = obj.sweepsetToAppend;
obj = rmfield(obj, 'sweepsetToAppend');

% Cacheing info - to be used in the future?
obj.cachedSweepset    = sweepset;
obj.allowsCacheing    = false;

% Structure to hold changes to underlying data
obj.modifiedData = i_sortFields(struct('dataValues', sparse(0,0),...
    'dataPosition', sparse(false(0)),...
    'rowGuid', guidarray,...
    'columnName', {{}},...
    'validRows', 0,...
    'validCols', 0,...
    'fullPosition', sparse(0,0)));

% Filter on guid and sweep
obj.filterGuid = guidarray;
obj.sweepFilters = i_sortFields(struct('filterExp',{},'result',{},'inlineExp',{},'filterResult',{},'OK',{}));

% Ensure that filters and variables have inline expression fields
if isempty(obj.filters)
    obj.filters = struct('filterExp',{},'result',{},'inlineExp',{},'filterResult',{},'OK',{});
else    
    % Generate the filter result logical array - for compatability this is
    % scalar expanded to false
    filterResult = false;
    for i = 1:length(obj.filters)
        % Add the mbcinline object to the internal storage
        obj.filters(i).inlineExp = vectorize(mbcinline(obj.filters(i).filterExp));
        obj.filters(i).filterResult = filterResult;
        obj.filters(i).OK = ~strncmp('Error', obj.filters(i).result, 5);
    end
end
% Sort the filters array
obj.filters = i_sortFields(obj.filters);

if isempty(obj.variables)
    obj.variables = struct('varName',{},'varExp',{},'varUnit',{},'varString',{},'result',{},'inlineExp',{},'OK',{});
else    
    for i = 1:length(obj.variables)
        obj.variables(i).inlineExp = vectorize(mbcinline(obj.variables(i).varExp));
        obj.variables(i).varUnit = '';
        obj.variables(i).OK = ~strncmp('Error', obj.variables(i).result, 5);
    end
end
% Sort the variables array
obj.variables = i_sortFields(obj.variables);

% Add sweep note structure
obj.sweepNotes = i_sortFields(struct('noteExp',{},'noteString',{},'lAppliesTo',{},'isMultiNote',{},'result',{},'OK',{},'inlineExp',{}));

% Add the data message service field
obj.dataMessageService = [];

% Ensure that defineTests contains the testnumAlias field and old
% reordering is flaged for maintaing compatability
if ~isempty(obj.defineTests)
    if ~isfield(obj.defineTests, 'testnumAlias')
        obj.defineTests.testnumAlias = 0;
    end
    if obj.defineTests.reorder
        obj.defineTests.reorder = 'OldReorder-ThisFieldShouldBeLogical';
    end
        
    % Convert previous zero tolerance settings to eps.  This will make
    % sure that, for example, LOGNO will continue to group sweeps
    % correctly.
    obj.defineTests.tolerance(obj.defineTests.tolerance==0) = eps;
end

% --------------------------------------------------------------------
% Convert version 2 sweepsetfilters to version 3
% --------------------------------------------------------------------
function obj = i_V2toV3(obj)
obj.version = 3;
% Need to add the note color to the note structure
if ~isfield(obj.sweepNotes, 'noteColor')
    if isempty(obj.sweepNotes)
        obj.sweepNotes = struct('OK',{},'inlineExp',{},'isMultiNote',{},'lAppliesTo',{},'noteColor',{},'noteExp',{},'noteString',{},'result',{});
    else
        for i = 1:length(obj.sweepNotes)
            obj.sweepNotes(i).noteColor = [1 0 0];
        end
        % Sort the sweep notes structure
        obj.sweepNotes = i_sortFields(obj.sweepNotes);
    end
end


% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function obj = i_sortFields(obj)
% Convert the structure to a cell array
cells = struct2cell(obj);
% Sort the fieldnames
[sortedFieldnames, i] = sort(fieldnames(obj));
% Recreate the structure in the correct order
obj = cell2struct(cells(i,:,:), sortedFieldnames);
