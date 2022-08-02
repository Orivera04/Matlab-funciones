function ptrlist=getptrsnomod(obj)
%GETPTRSNOMOD  Return all pointers exept those in models
%
%  PTRLIST = GETPTRSNOMOD(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:19 $

ptrlist = [getptrsnomod(obj.cgexpr); getptrs(obj.conobj)];