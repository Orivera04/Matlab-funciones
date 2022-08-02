function [dataset,info] = linkdataset(dataset,info)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:52:07 $
names = get(dataset,'factors');
oldptr = get(dataset,'ptrlist');
if nargin == 1
	% link to CAGE xregpointers
	info = [];
	e = cg_front('get_exprlist');
	elist = lower(char(e));
	if isempty(e) | isempty(elist)
		newptr = [];
	else
		
		for i = 1:length(oldptr)
			if isvalid(oldptr)
				name = oldptr(i).getname;
				dataset.orig_name{i} = name;
				index = strmatch(lower(name),elist(:,1),'exact');
				if isempty(index)
					info(i).newptr = xregpointer;
					dataset.ptrlist(i) = xregpointer;
				else
					info(i).newptr = e(index);
					dataset.ptrlist(i) = e(index);
				end
				dataset.orig_name{i} = name;
			else
				name = dataset.orig_name{i};
				info(i).newptr = oldptr(i);
			end
			info(i).oldptr = oldptr(i);
			info(i).name = name;
		end
	end
elseif nargin == 2
	% revert to previous xregpointers if possible
	for i = 1:length(info)
		ind = strmatch(info(i).name,dataset.orig_name);
		if isempty(ind)
			ind = findname(dataset,info(i).name);
		end
		if ~isempty(ind)
			dataset.ptrlist(ind) = info(i).oldptr;
		end
	end
end
