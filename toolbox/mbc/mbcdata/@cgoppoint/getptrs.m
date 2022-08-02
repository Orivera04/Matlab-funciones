function ptrlist=getptrs(m)
% cgOpPoint get pointers method
% ptrlist=getptrs(m)
%	Recursive call to return xregpointers contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:51:52 $


p=[];
if ~isempty(m.ptrlist)
   p=[p; m.ptrlist(m.ptrlist~=0).'];
end
if ~isempty(m.linkptrlist)
   p=[p; m.linkptrlist(m.linkptrlist~=0).'];
end

ptrlist=p;
for i=1:length(p)
   % recursive call to children
   ptrlist=[ptrlist; getptrs(info(p(i)))];
end
if isempty(ptrlist)
   ptrlist=[];   % convert to empty xregpointer to empty array
end
