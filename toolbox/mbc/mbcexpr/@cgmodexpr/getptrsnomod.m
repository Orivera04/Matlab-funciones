function ptrlist=getptrsnomod(m)
%GETPTRSNOMOD cgmodexpr get xregpointers method
%
%  ptrlist = GETPTRSNOMOD(m) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:10 $

ptrlist=[];