function MP= saveobj(MP);
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:06:49 $



refs= preorder(MP,'getptrs');

if ~isempty(refs)
	% save file
	
	if iscell(refs)
		refs= [refs{:}];
	end
	refs = unique(refs);
	% remove null pointers from list
	refs= refs(refs~=0);
	
	% storage for heap inside the mdevproject object
	heap.ptrs= refs;
	heap.info= info(refs);
	
	if ~iscell(heap.info)
		heap.info= {heap.info};
	end
	
	MP.modeldev= saveobj(MP.modeldev);
	
	% update the file history
	MP.History= [MP.History struct('User', initfromapp(mbcuser),...
         'Action',['Project modified by ' getusername(initfromprefs(mbcuser))],...
         'Date', now)];
	
	% delete the dynamic copy of the mdev project
	ind= find(heap.ptrs==address(MP));
	heap.info(ind)= [];
	heap.ptrs(ind)= [];
	
	for i=1:length(heap.info)
		obj= heap.info{i};
		if isobject(obj)
			heap.info{i} = saveobj(obj);
		end
	end
else
	heap= [];
end
MP.heap= heap;

MP.SavedMBCVersion = mbcver;
hExt = xregtools.extensions;
MP.SavedAddonVersions = [hExt.AddonNames(:), hExt.AddonVersions(:)];