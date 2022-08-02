function pNode = findptr(nd, ptrs)
%FINDPTR Look for pointers inthis node
%
%  PNODE = FINDPTR(ND, PTRS) checks for instances of any of the pointers in
%  PTRS within the node ND.  If any exist, the node pointer is returned,
%  otherwise an empty pointer array is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:47:45 $ 

allptrs = getptrs(nd);
if anymember(ptrs, allptrs)
    pNode = address(nd);
else
    pNode = assign(xregpointer, []);
end