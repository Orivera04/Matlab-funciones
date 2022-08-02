function obj = set(obj, Properties, Values);
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:13 $

valid_props = {'reorder' 'label' 'date' 'comment'};

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
	obj = valid_props';
	return
end

ISCHAR = ischar(Properties);
if ISCHAR
	Properties = {Properties};
	Values = {Values};
end

for i = 1:length(Properties)
	property = lower(Properties{i});
	mInd = strmatch(property, valid_props);
	if isempty(mInd) | length(mInd) > 1
		error(['Ambiguous or invalid sweepsetfilter property: ' property]);
	end
    switch mInd
        case 1
            % Reorder
            obj = reorderSweeps(obj, Values{i});
        case 2
            % label
            obj = i_setName(obj, Values{i});
        case 3
            % Date
            obj = i_setDate(obj, Values{i});
        case 4
            % Comment
            obj = i_setComment(obj, Values{i});
            
    end
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_setName(obj, newName)
if ~ischar(newName)
	error('Sweepsetfilter name property must be a character array');
end
obj.name = newName;
% Tell everyone that the name has changed
queueEvent(obj, 'ssfNameChanged');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_setDate(obj, newDate)
if isnumeric(newDate)
	newDate = datestr(newDate);
end
if ~ischar(newDate)
	error('Sweepsetfilter date property must be a character array');
end
obj.date = newDate;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_setComment(obj, newComment)
if ~ischar(newComment)
	error('Sweepsetfilter commment property must be a character array');
end
obj.comment = newComment;




