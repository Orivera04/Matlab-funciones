function p = xregpointer(info)
%XREGPOINTER Pointer class constructor
%
%  p = XREGPOINTER(newinfo) allocates space on the heap and places newinfo
%  in it. 
%  p = XREGPOINTER returns a null pointer.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:48:23 $

if nargin==0
    p.ptr = 0;
else
    p.ptr = HeapManager(4, 1, {info});
end

p = class(p,'xregpointer');
