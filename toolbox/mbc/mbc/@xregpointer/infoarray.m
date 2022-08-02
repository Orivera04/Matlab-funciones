function inf = infoarray(p)
%INFOARRAY Return information pointed to by p
%
%  DATA = INFOARRAY(P) returns the data that is being stored at the pointer
%  heap locations pointed to by P.  DATA will be a cell array of the same
%  size as P with each cell containing the data pointed to by the
%  corresponding pointer.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:47:13 $

inf = HeapManager(1,p.ptr);
