function D = replace(D,old,new)
%REPLACE  Replace one variable with another
%
%  Replace all instances in the whole session of one item in the dd to
%  another
%
%  D = replace(D,oldPtr,newPtr)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:23:47 $

proj = project(D);
allitems = preorder(proj,'getptrs');
allitems = [allitems{:}];
allitems = unique(allitems(isvalid(allitems)));

% Remapping just one pointer causes warnings that other pointers haven't been matched
% (This is a feature designed to make sense during loading)
oldwarn = warning('off','mbc:xregpointer:PointerMatch');    
RefMap = {old,new};
for k = 1:length(allitems)
    allitems(k).info = mapptr(allitems(k).info,RefMap);
end
warning(oldwarn);

D = remove(D, old);