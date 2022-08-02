function p = new(p,info)
%NEW Allocates new dynamic memory location
%
%  p = NEW(p, info) creates a new pointer location on the heap.  If the
%  second argument, info, is provided it is placed at the new pointer
%  location.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:47:24 $

if nargin > 1
    p.ptr = HeapManager(4, 1, {info});
else
    p.ptr = HeapManager(4, 1);
end
