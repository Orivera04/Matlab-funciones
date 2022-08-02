function inf = info(p)
%INFO Return information pointed to by p
%
%  DATA = INFO(P) returns the data that is being stored at the pointer heap
%  location pointed to by P.  If P is a scalar pointer, DATA will be the
%  actual information at that location.  If P is an array, DATA will be a
%  cell array of the same size with each cell containing the data pointed
%  to by the corresponding pointer.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:47:12 $

inf = HeapManager(0,p.ptr);
