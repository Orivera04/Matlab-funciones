function p= mapptr(p,RefMap)
% XREGPOINTER/MAPPTR maps pointer from old to new references
%
% p= mapptr(p,{OldRefs,NewRefs})
%     This is mainly for use in loading pointers to new locations

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:22 $

OldRefs= RefMap{1};
NewRefs= RefMap{2};

if ~isempty(p.ptr)
	ind= mbcbinsearch(OldRefs.ptr,p.ptr);
	ok= ind~=0 & p.ptr~=0;
	if any(ind==0 & p.ptr~=0)
		warning('mbc:xregpointer:PointerMatch', 'Unmatched pointer(s).')
	end
	p.ptr(ok)= NewRefs.ptr(ind(ok));
end

