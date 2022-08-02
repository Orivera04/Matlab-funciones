function out=freeptr(m)
% cgexprmodel/FREEPTR
% Called by xregpointer/freeptr
% []=free(e)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:49:39 $
ptrlist = m.allPtrs;
for i = 1:length(m.allPtrs)
   tmp=m.allPtrs(i).getptrs;
   ptrlist = [ptrlist(:); tmp(:)];
end
freeptr(unique(ptrlist));