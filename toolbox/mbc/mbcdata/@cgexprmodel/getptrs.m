function ptrlist=getptrs(m)
% cgExprModel get pointers method
% ptrlist=getptrs(m)
%	Recursive call to return pointers contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:42 $
ptrlist = [];
if ~isempty(m.modObj)
    ptrlist = getptrs(m.modObj);
end
for i = 1:length(m.allPtrs)
    if isvalid(m.allPtrs(i))
        ptrlist = [ptrlist;m.allPtrs(i);m.allPtrs(i).getptrs];
    end
end



