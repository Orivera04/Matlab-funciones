function values = getAllows(obj, Properties);
%GETALLOWS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:51 $

valid_props = {'modifydata' 'variables' 'filters' 'definetests' 'reorder'};

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
	Properties = valid_props;
end

ISCHAR = ischar(Properties);
if ISCHAR
	Properties = {Properties};
end

values = cell(1,length(Properties));
Properties = lower(Properties);

% Get flag settings
f = getFlags;

for i = 1:length(Properties)
	property = Properties{i};
	mInd = strmatch(property, valid_props);
	if isempty(mInd) | length(mInd) > 1
		error(['Ambiguous sweepsetfilter function: ' property]);
	end
	switch mInd
	case 1
		% modifydata
		values{i} = bitget(obj.allowsFlag, f.APPLY_DATA);
	case 2
		% variables
		values{i} = bitget(obj.allowsFlag, f.APPLY_VARS);
	case 3
		% filters
		values{i} = bitget(obj.allowsFlag, f.APPLY_FILT);
	case 4
		% definetests
		values{i} = bitget(obj.allowsFlag, f.APPLY_TEST);
	case 5
		% reorder
		values{i} = bitget(obj.allowsFlag, f.APPLY_REOR);
	end
end

if ISCHAR
	values = values{1};
end

if ALLPROPS
	values = cell2struct(values, valid_props, 2);
end