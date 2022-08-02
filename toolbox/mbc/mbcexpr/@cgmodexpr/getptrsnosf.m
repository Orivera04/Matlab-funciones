function ptrlist=getptrsnosf(m)
%GETPTRSNOSF cgmodexpr get xregpointers method
%
%  ptrlist=getptrsnosf(m) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:11 $

ptrlist = getptrsnosf(m.cgexpr);

% The model pointers are returned without any variable items: this is to
% work around bugs in pointer handling in cgexpr/eval
pModel = getptrs(m.model);
isddvar = pveceval(pModel, 'isddvariable');

ptrlist = [ptrlist; pModel(~[isddvar{:}])];