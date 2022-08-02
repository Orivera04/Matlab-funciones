function pDup = getduplicationptrs(T)
%GETDUPLICATIONPTRS Return the pointers required for duplicating a node
%
%  P_DUP = GETDUPLICATIONPTRS(T) returns a (1xn) xregpointer vector
%  containing the pointers that need to be duplicated when the tree node
%  is copied.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:24:55 $ 

% cgnode returns all pointers except Variable Dictionary items
pDup = getptrs(T);
keep = true(size(pDup));
for n = 1:length(pDup)
    keep(n) = ~pDup(n).isddvariable;
end
pDup = pDup(keep);