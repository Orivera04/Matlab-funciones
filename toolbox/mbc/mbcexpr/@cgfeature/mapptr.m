function SF = mapptr(SF,RefMap);
%MAPPTR Remap object pointers
%
%  OBJ = MAPPTR(OBJ, REFMAP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:50 $

SF.eqexpr = mapptr(SF.eqexpr,RefMap);
SF.modelexpr = mapptr(SF.modelexpr,RefMap);
SF.oppoint = mapptr(SF.oppoint,RefMap);
SF.cgexpr = mapptr(SF.cgexpr, RefMap);
