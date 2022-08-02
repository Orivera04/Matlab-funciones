function p= getptrs(nd);
%GETPTRS list of internal pointers
%
%  PTRS = GETPTRS(ND)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:25 $

p=getptrs(nd.cgcontainer);
allp = nd.ptrlist;
for i=1:length(allp)
   p=[p, allp(i), getptrs(info(allp(i)))'];
end