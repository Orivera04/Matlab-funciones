function pDup = getduplicationptrs(nd)
%GETDUPLICATIONPTRS Return the pointers required for duplicating a node
%
%  P_DUP = GETDUPLICATIONPTRS(T) returns a (1xn) xregpointer vector
%  containing the pointers that need to be duplicated when the tree node
%  is copied.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.3 $    $Date: 2004/02/09 08:37:41 $ 

% cgtradeoffnode returns just the basic node pointers
pDup = [address(nd), children(nd)];
