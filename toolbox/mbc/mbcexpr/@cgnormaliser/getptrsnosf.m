function ptrlist = getptrsnosf(N);
%GETPTRSNOSF Return pointers except those in features
%
%  PTRS = GETPTRSNOSF(OBJ) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:57 $
  
if isempty(N.Xexpr);
    ptrlist = getptrsnosf(N.cglookup);
elseif isvalid(N.Xexpr)    
    ptrlist = [getptrsnosf(N.cglookup); N.Xexpr ; N.Xexpr.getptrsnosf];
else
    ptrlist = getptrsnosf(N.cglookup);
end
