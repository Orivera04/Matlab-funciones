function obj = mapptr(obj,RefMap)
%MAPPTR Maps pointer from old to new references
%
%  p= MAPPTR(p,OldRefs,NewRefs) is mainly used for loading pointers to new
%  locations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:37:55 $


obj.cgnode = mapptr(obj.cgnode, RefMap);

obj.Tables = mapptr(obj.Tables, RefMap);
obj.FillExpressions = mapptr(obj.FillExpressions, RefMap);
obj.FillMaskExpressions = mapptr(obj.FillMaskExpressions, RefMap);
obj.GraphExpressions = mapptr(obj.GraphExpressions, RefMap);
obj.GraphHideExpressions = mapptr(obj.GraphHideExpressions, RefMap);
