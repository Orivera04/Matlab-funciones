function obj = setAllows(obj, Properties, Values);
%SETALLOWS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:12:14 $

valid_props = {'modifydata' 'variables' 'filters' 'definetests' 'testfilters' 'reorder' 'derived'};

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
	obj = valid_props';
	return
end

if ischar(Properties)
	Properties = {Properties};
end

% Input values can be strings or double arrays or cell arrays of strings
if ischar(Values) || (iscell(Values) && ischar(Values{1}))
    Values = strcmp(Values, 'on');
elseif iscell(Values)
    Values = [Values{:}];
else
    Values = Values(:);
end

% Scalar expansion to size of properties
if numel(Values) == 1
    Values = repmat(Values, size(Properties));
end

% Get flag settings
f = getFlags;

% What are the allowed properties before
INITIAL_ALLOWS = obj.allowsFlag;

for i = 1:length(Properties)
	property = lower(Properties{i});
	mInd = strmatch(property, valid_props);
	if isempty(mInd) || length(mInd) > 1
		error(['Ambiguous or invalid sweepsetfilter function: ' property]);
	end
	switch mInd
	case 1
		% modify data
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_DATA, Values(i));
	case 2
		% variables
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_VARS, Values(i));
	case 3
		% filters
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_FILT, Values(i));
	case 4
		% definetests
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_TEST, Values(i));
    case 5
        % test filters
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_SFILT, Values(i));
	case 6
		% reorder
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_REOR, Values(i));
    case 7
        % derived
		obj.allowsFlag = bitset(obj.allowsFlag, f.APPLY_DERIVED, Values(i));        
	end
end

% May need to update the cache to reflect changes in the flag
if ~isequal(INITIAL_ALLOWS, obj.allowsFlag)
    obj = updateCache(obj);
end