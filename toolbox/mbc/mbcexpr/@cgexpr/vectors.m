function out = vectors(e)
%VECTORS Return pointers to input vectors
%
%  X = vectors(e) returns xregpointers to the values involved in the
%  evaluation of e that contain vector inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:52 $

ptrs = getinports(e);
ptrs = unique(ptrs);
isvect = false(size(ptrs));
for n = 1:length(ptrs)
    if length(ptrs(n).getvalue) > 1
        isvect(n) = true;
    end
end
out = ptrs(isvect);
out = cgvarminlist(out);