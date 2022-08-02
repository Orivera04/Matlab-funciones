function ptrlist = getptrsnosf(NF);
%GETPTRSNOSF Return pointers except those in features
%
%  PTRS = GETPTRSNOSF(OBJ) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:47 $
  
if isempty(NF.Xexpr);
    ptrlist = getptrsnosf(NF.cglookup);
elseif isvalid(NF.Xexpr)    
    ptrlist = [getptrsnosf(NF.cglookup); NF.Xexpr ; NF.Xexpr.getptrsnosf];
else
    ptrlist = getptrsnosf(NF.cglookup);
end