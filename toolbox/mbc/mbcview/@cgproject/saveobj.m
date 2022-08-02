function PROJ= saveobj(PROJ);
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:28:26 $

refs= preorder(PROJ,'getptrs');

if ~isempty(refs)
   % save file	
   if iscell(refs)
      refs= [refs{:}];
   end
   refs = unique(refs);
   % remove null pointers from list
   refs= refs(refs~=0);
   
   % storage for heap inside the cgproject object
   heap.ptrs= refs;
   heap.info= info(refs);
   
   if ~iscell(heap.info)
      heap.info= {heap.info};
   end
   
   % delete the dynamic copy of the cgproject
   ind= find(heap.ptrs==address(PROJ));
   heap.info(ind)= [];
   heap.ptrs(ind)= [];
   
   % execute saveobj on all heap objects
   for i=1:length(heap.info)
      obj= heap.info{i};
      if isobject(obj)
         heap.info{i} = saveobj(obj);
      end
   end
else
   heap= [];
end
PROJ.heap= heap;

PROJ.SavedMBCVersion = mbcver;
hExt = cgtools.extensions;
hExtModel = xregtools.extensions;  % Model Browser tools may affect Cage items
PROJ.SavedAddonVersions = [hExt.AddonNames(:), hExt.AddonVersions(:); ...
        hExtModel.AddonNames(:), hExtModel.AddonVersions(:)];