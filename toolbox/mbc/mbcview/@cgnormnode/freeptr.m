function freeptr(obj)
%FREEPTR React to object's pointer being freed
%
%  FREEPTR(OBJ) has been overloaded for this object to first check its
%  tree-location before intiating a project-wide pointer search

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:25:31 $ 

p = project(obj);
if ~beingdeleted(p) && Parent(obj)==address(p)
    % Only do this process if the node is not beneath a table
    sub_ptrs = getptrs(info(getdata(obj)));
    ptrs = [getdata(obj), sub_ptrs(:)'];
    ptnow = preorder(p, @getptrs);
    ptnow = [ptnow{:}];
    freeptr(ptrs(~ismember(ptrs, ptnow)));
end
