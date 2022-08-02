function pDup = getduplicationptrs(nd)
%GETDUPLICATIONPTRS Return the pointers required for duplicating a node
%
%  P_DUP = GETDUPLICATIONPTRS(T) returns a (1xn) xregpointer vector
%  containing the pointers that need to be duplicated when the tree node
%  is copied.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:21:47 $ 

% cgdatasetnode returns just the dataset pointer plus the basic node
% pointers plus some internal dataset pointers
pOpPt = getdata(nd);
OpPtPtrs = get(pOpPt.info, 'ptrlist');
OpPtPtrs_internal = isUniqueToDataset(pOpPt.info) & ~isnull(OpPtPtrs);
pDup = [address(nd), getdata(nd), OpPtPtrs(OpPtPtrs_internal)];
