function index = findName(d,name)
% cgOpPoint / findName

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:40 $
index = [];
if isa(name,'pointer')
	for i = 1:length(name)
		this = find(name(i) == d.ptrlist);
		if isempty(this)
			index = [];
			return
		else
			index = [index;this];
		end
	end
else
	names = get(d,'factors');	
	if ~isempty(names)
		names = strrep(names,'(','');
		names = strrep(names,')','');
		if ischar(name)
			name = {name};
		end
		for i = 1:length(name)
			this = strmatch(lower(name{i}),lower(names),'exact');
			if isempty(this)
				index = [];
				return
			end
			index = [index;this];
		end
	end
end