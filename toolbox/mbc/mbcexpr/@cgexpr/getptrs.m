function ptrs=getptrs(v)
%GETPTRS Return pointers in object
%
%  PTRS = GETPTRS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:08:48 $

ptrs = pveceval(v.Inputs, 'getptrs');
ptrs = cat(1, v.Inputs(:), ptrs{:});