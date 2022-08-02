function [obj,createdPtrs,valPtrs,oldValPtrs,changes] = cgexprcopy(e,flag)
% CGEXPRCOPY
% newPtr = cgexprcopy(oldPtr)
% newPtr = cgexprcopy(oldPtr,useOldValues)
% returns a complete copy of the old ptr and all it points to 
% instead of just a new pointer pointing at the old object
% oldPtr can be an expression object rather than a pointer to an object
% if useOldValues == 1
%	include pointers to the existing value objects
% else
%	create copies of all objects including value objects
% end
%
% [newPtr,createdPtrs,valPtrs] = cgexprcopy(oldPtr,copyValues)
% createdPtrs is a collection of all new ptrs which would need to be put onto 
% an exprlist for example (newPtr is always in createdPtrs)
% valPtrs are the old values still referenced 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:17:08 $

% Do some input checking first
if nargin == 1
	flag = 0;
end
if isa(e,'xregpointer') & isvalid(e)
	obj = e.info;
else
	obj = e;
end
p = [];newP = [];createdPtrs = [];valPtrs = [];oldValPtrs = [];allP = [];
if ~isa(obj,'cgexpr') 
	% inputs are not correct do nothing and return empty
else
	% inputs are OK, carry on
	newP = [];
	allP = getptrs(obj);  % Vector of existing pointers 
	if isempty(allP)
		return
	end
end
if isa(obj,'cglookup')
    try
        sflist = get(obj,'sflist');
        obj = UpdateSFlist(obj,sflist,0);
    end	
    if isa(obj,'cgnormaliser')
        obj = set(obj,'flist',[]);
    end	
end
DallP = double(allP);
% Will be a vector of copies of allP
seen = [];
for i=1:length(allP)
	if ~ismember(DallP(i),seen) %make sure it is unique without having to do a sort
		seen = [seen DallP(i)];
        this = allP(i).info;
        if iscalibratable(this)
            try
                sflist = get(this,'sflist');
                this = UpdateSFlist(this,sflist,0);
            end	
            if isa(this,'cgnormaliser')
                this = set(this,'flist',[]);
            end	
            newP = [newP;xregpointer(this)];
        elseif isddvariable(this)
			if flag
				newP = [newP;allP(i)];
				valPtrs = [valPtrs;allP(i)];
			else
				newP = [newP;xregpointer(this)];
				valPtrs = [valPtrs;newP(end)];
				oldValPtrs = [oldValPtrs;allP(i)];
            end
        else
			newP = [newP;xregpointer(this)];
		end
	end
end
DallP = seen;
allP = assign(xregpointer,DallP);
if isempty(newP)
	createdPtrs = [];
else
	% Now we need to change all instances of an old pointer in the new set
	% with the corresponding new pointer.
	DnewP = double(newP);
	changed = find(DnewP(:) ~= DallP(:));
	allP = allP(:);
	old = allP(changed);
	new = newP(changed);
	[old,ind,ind2] = unique(old);
	new = new(ind);
	changes = [old new];  %like 'dummy' in append routine
	RefMap{1} = old;
	RefMap{2} = new;
	for i=1:length(newP)
		% for every object in the list
		% update only the pointers which have changed
		%for j = changed'
		newP(i).info = newP(i).mapptr(RefMap);
		%end
	end
	obj = mapptr(obj,RefMap);
	createdPtrs = newP([1;changed]);
	if ~isempty(createdPtrs)
		createdPtrs = unique(createdPtrs);
	end
end

dCreatedPtrs = double(createdPtrs(:));
ind = [];
if ~flag
	dValPtrs = double(valPtrs); 
	for i = 1:length(dValPtrs)
		ind(i) = find(dValPtrs(i) == dCreatedPtrs);
	end
	valPtrs = ind;
end



