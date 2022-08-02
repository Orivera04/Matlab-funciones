function ok = isvalid(p)
%ISVALID Checks validity of pointer
%  
%  OK = ISVALID(P) returns true if P is a valid pointer, false otherwise.
%  If P is a pointer array, OK will be a logical array of the same size.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:47:19 $

ok = HeapManager(9, p.ptr);
