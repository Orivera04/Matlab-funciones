function pDup = getduplicationptrs(nd)
%GETDUPLICATIONPTRS Return the pointers required for duplicating a node
%
%  P_DUP = GETDUPLICATIONPTRS(T) returns a (1xn) xregpointer vector
%  containing the pointers that need to be duplicated when the tree node
%  is copied.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:25:34 $ 

% cgnormnode returns just the basic node pointers
if address(project(nd))==Parent(nd) && issimpletable(info(getdata(nd)))
    pDup = [address(nd); getdata(nd)];
else
    pDup = address(nd);
end