function obj = sweepsetfilter(pSweepset, nameStr, dateStr)
%SWEEPSETFILTER Constructor
%
% SSF = SWEEPSETFILTER( PTR_SWEEPSET, NAME, DATE )
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:12:25 $

if nargin && isstruct(pSweepset)
    % Check if we are being called from loadobj with a structure
    obj = pSweepset;
elseif nargin && isa(pSweepset, 'sweepsetfilter')
    % Overloaded sweepsetfilter cast to allow derived objects to implement
    % a call to sweepsetfilter and return an ssf
    obj = pSweepset;
    return
else
    % Initialise correctly for zero orgument constructor
    if nargin < 1
        pSweepset = xregpointer;
    end
    if nargin < 2
        nameStr = '';
    end
    if nargin < 3
        dateStr = datestr(now);
    end
    
    if ~(isa(pSweepset, 'xregpointer') && length(pSweepset) == 1)
        error('SweepsetFilter must be created with one input argument, a valid pointer of size 1x1');
    end
    % Create the empty structure with fields in the correct alphabetic
    % order - then fill them in during construction
    obj = struct(...
        'allowsCacheing', [],...
        'allowsFlag', [],...
        'cachedSweepset', [],...
        'comment', [],...
        'dataMessageService', [],...
        'date', [],...
        'defineTests', [],...
        'filterGuid', [],...
        'filters', [],...
        'modifiedData', [],...
        'name', [],...
        'pSweepset', [],...
        'recordsToRemove', [],...
        'reorderSweeps', [],...
        'sweepFilters', [],...
        'sweepNotes', [],...
        'sweepsToRemove', [],...
        'variableSweepset', [],...
        'variables', [],...
        'variablesToKeep', [],...
        'version', 3);
        
    
    % Pointer to the underlieing sweepset
    obj.pSweepset = pSweepset;
    
    % Information about the filters being applied
    % ---------------------------------------------------------------------
    % filterExp - the string expression  of the filter
    % result - indicates sucess in applying the filter
    % inlineExp - mbcinline version of the filter
    % filterResult - logical result of the filter
    % OK - boolean indicating sucessful application of the filter
    obj.filters = struct(...
        'OK',{},...
        'filterExp',{},...
        'filterResult',{},...
        'inlineExp',{},...
        'result',{});
    
    obj.sweepFilters = struct(...
        'OK',{},...
        'filterExp',{},...
        'filterResult',{},...
        'inlineExp',{},...
        'result',{});
    
    obj.filterGuid = guidarray;
    
    % Cached info that allows the filters to be applied
    obj.recordsToRemove   = [];
    obj.sweepsToRemove    = {};
    obj.variablesToKeep   = {};
      
    % Cacheing info
    obj.cachedSweepset    = [];
    obj.allowsCacheing    = false;
    
    % Reordering information .. both new dataset and sweep order
    obj.reorderSweeps = {};
    obj.defineTests = struct('variable',{},...
        'tolerance',{},...
        'reorder',{},...
        'testnumAlias',{});
    
    % Information about the user-defined variables added
    % ---------------------------------------------------------------------
    % varName - name of the variable being added
    % varExp - expression defining the new variable
    % varString - similar to the string used to construct the variable [varName ' = ' varExp]
    % result - indicates sucess in add the variable
    % OK - boolean indicating sucessful application of the variable
    % inlineExp - mbcinline version of the variable expression
    obj.variables = struct(...
        'OK',{},...
        'inlineExp',{},...
        'result',{},...
        'varExp',{},...
        'varName',{},...
        'varString',{},...
        'varUnit',{});

    % Cached copy of the user-defined variables
    obj.variableSweepset = [];
    
    % Information about sweep notes in alphabetic order
    % ---------------------------------------------------------------------
    % noteExp - the string expression that represents the note
    % noteString - the string to be displayed where the note is applied
    % noteColor - The color triple associated with the note
    % lAppliesTo - a logical vector which holds which sweeps the note applies to
    % isMultiNote - a boolean that indicates noteExp returns multiple notes
    %             - not used at present
    % result - indicates that noteExp was applied sucessfully
    % OK - boolean indicateing successful application of the note
    % inlineExp - holds the mbcinline version of the note
    obj.sweepNotes = struct(...
        'OK',{},...
        'inlineExp',{},...
        'isMultiNote',{},...
        'lAppliesTo',{},...
        'noteColor',{},...
        'noteExp',{},...
        'noteString',{},...
        'result',{});
    
    % Structure to hold changes to underlying data - dataValues is a sparse
    % array of changes to data indexed on the row by guid and column by
    % variable name. dataPosition indicates which values are applicable
    % ---------------------------------------------------------------------
    % dataValues - sparse matrix holding the new data values
    % dataPosition - sparse logical matrix indicating which values in
    %      dataValues are relevent changes
    % rowGuid - guidarray that indicates which row of the sweepset is
    %      modified by the coresponding row in dataValues
    % columnName - cell array of string that indicates which column of the
    %      sweepset is modified by the coresponding column in dataValues
    % validRows - indicates the number of valid rows in dataValues
    % validCols - indicates the number of valid columns in dataValues
    %      Note that some guids or columnNames might not be found in the
    %      underlying sweepset and those rows/cols need to be placed at the
    %      end of the sparse matricies. Within the sparse matricies the
    %      guids and columns that do exist are ordered as found in the
    %      underlying sweepset.
    % fullPosition - logical sparse matrix which locates which elements in
    %      the underlying matrix need modification. This matrix needs
    %      updateing every time the underlying sweepset changes
    obj.modifiedData = struct(...
        'columnName', {{}},...
        'dataPosition', sparse(false(0)),...
        'dataValues', sparse(0,0),...
        'fullPosition', sparse(0,0),...
        'rowGuid', guidarray,...
        'validCols', 0,...
        'validRows', 0);
    
    % Allows flag (set all properties on by default)
    obj.allowsFlag = bitmax;
    
    % Information about this object
    obj.name = nameStr;
    obj.date = dateStr;
    obj.comment = '';
    
    % Event sending object to broadcast change information
    obj.dataMessageService = [];
end

% Reorder the sweepsetfilter fields alphabetically
obj = i_sortFields(obj);

obj = class(obj, 'sweepsetfilter');

% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function obj = i_sortFields(obj)
% Convert the structure toa cell array
cells = struct2cell(obj);
% Sort the fieldnames
[sortedFieldnames, i] = sort(fieldnames(obj));
% Recreate the structure in the correct order
obj = cell2struct(cells(i,:,:), sortedFieldnames);
