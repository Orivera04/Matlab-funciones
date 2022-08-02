function p = clone(p)
% XREGPOINTER/CLONE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:46:59 $

ptrs = [p getptrs(info(p))];
ptrs.ptr= ptrs.ptr(ptrs.ptr~=0);
nPtrs = copy(ptrs);
p.ptr = nPtrs.ptr(1);