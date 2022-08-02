function values = get(obj, Properties, index);
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:08:50 $

valid_props = {'filters' 'variables' 'removedrecords' 'varsweepset' 'reordersweeps' 'label'...
		'date' 'comment' 'keepvariables' 'definetests' 'notes' 'sweepnotes' 'cache' 'sweepfilters' 'removedsweeps'...
        'serializefilters' 'serializevariables' 'serializesweepfilters' 'serializesweepnotes' ...
        'guidfilters', 'modifieddata'};

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
	Properties = valid_props;
end

% Have we been given an index value
INDEXED = nargin > 2;

ISCHAR = ischar(Properties);
if ISCHAR
	Properties = {Properties};
end

values = cell(1,length(Properties));
Properties = lower(Properties);


for i = 1:length(Properties)
	property = Properties{i};
	mInd = strmatch(property, valid_props);
	if length(mInd) > 1
		error(['Ambiguous sweepsetfilter property: ' property]);
	end
	if isempty(mInd)
		% Are any properties to be got from the object being filtered
		ss = sweepset(obj);
		% MAX and MIN need to be re-initialised before getting
		if strcmp(property, 'MIN') | strcmp(property, 'MAX')
			ss = SetMinMax(ss);
		end
		values{i} = get(ss, property);
	else	
		switch mInd
		case 1
			% filters
			values{i} = obj.filters;
			if INDEXED
				values{i} = values{i}(index);
			end
		case 2
			% variables
			values{i} = obj.variables;
			if INDEXED
				values{i} = values{i}(index);
			end
		case 3
			% removedRecords
			values{i} = obj.recordsToRemove;
		case 4
			% varSweepset
			values{i} = obj.variableSweepset;
		case 5
			% Reorder variable
			values{i} = obj.reorderSweeps;
		case 6
			% Label (not name because sweepset has 'name')
			values{i} = obj.name;
		case 7
			% Date
			values{i} = obj.date;
		case 8
			% Comment
			values{i} = obj.comment;
		case 9
			% keep variables
			values{i} = obj.variablesToKeep;
		case 10
			% Define Tests
			values{i} = obj.defineTests;
        case 11
            % Notes
            values{i} = i_getAllSweepNotes(obj);
        case 12
            % SweepNotes
            values{i} = obj.sweepNotes;
			if INDEXED
				values{i} = values{i}(index);
			end
        case 13
            % Cache state
            values{i} = obj.allowsCacheing;
        case 14
            % Sweep filters
            values{i} = obj.sweepFilters;
			if INDEXED
				values{i} = values{i}(index);
			end
		case 15
			% removedSweeps
			values{i} = obj.sweepsToRemove;
        case 16
            % serializefilters
            values{i} = {obj.filters.filterExp}';
        case 17
            % serializevariables
            values{i} = [ {obj.variables.varString}' {obj.variables.varUnit}' ];
        case 18
            % serializesweepfilters
            values{i} = {obj.sweepFilters.filterExp}';
        case 19
            % serializesweepnotes
            values{i} = [ {obj.sweepNotes.noteExp}' {obj.sweepNotes.noteString}' {obj.sweepNotes.noteColor}'];
        case 20
            % guid filter
            values{i} = obj.filterGuid;
        case 21
            % modified data
            values{i} = obj.modifiedData;
		end
	end
end

if ISCHAR
	values = values{1};
end

if ALLPROPS
	values = cell2struct(values, valid_props,2);
end


%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
function notesOut = i_getAllSweepNotes(obj)
% Check for uninitialised pointer
if ~isvalid(obj.pSweepset)
    notesOut = {};
    return
end

% Preinitialise the output cell array
notes = cell(size(obj, 3), length(obj.sweepNotes));
color = cell(size(obj, 3), length(obj.sweepNotes));

% Build up the sweep notes cell array
for i = 1:length(obj.sweepNotes)
    if any(obj.sweepNotes(i).lAppliesTo)
        % Copy the note into the notes array
        [notes{obj.sweepNotes(i).lAppliesTo, i}] = deal(obj.sweepNotes(i).noteString);
        % And the color into the color array
        [color{obj.sweepNotes(i).lAppliesTo, i}] = deal(obj.sweepNotes(i).noteColor);
    end
end

% Should we get the notes from the underlying object.
if isa(obj.pSweepset.info, 'sweepsetfilter') && isempty(obj.defineTests)
    parentNotes = obj.pSweepset.get('notes');
    notes = [parentNotes(:, 1) notes];
    color = [parentNotes(:, 2) color];
end

% Create the output cell array
notesOut = cell(size(notes, 1), 2);
% Concatenate all the sweeps together (note strvcat just calls char)
for i = 1:length(notesOut)
    notesOut{i, 1} = strvcat(notes{i, :});
    notesOut{i, 2} = vertcat(color{i, :});
end
