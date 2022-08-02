function nodes = findprimarynode(nd, item)
%FINDPRIMARYNODE A short description of the function
%
%  NDS = FINDPRIMARYNODE(ND ITEM) searches for nodes beneath ND that report
%  ITEM as being their primary item. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:24:52 $ 


nodes = preorder(nd, @i_findprimary, item);
if iscell(nodes)
    nodes = [nodes{:}];
end




function pNode = i_findprimary(nd, item)
if any(item==getprimaryitems(nd))
    pNode = address(nd);
else
    pNode = [];
end