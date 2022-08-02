function obj = selectModels(obj, idx)
%SELECTMODELS Create new switch model based on a subset of contained models
%
%  NEWOBJ = SELECTMODELS(OBJ, IDX) creates a new object, based on OBJ, that
%  contains only the valid switch points indexed by the index vector IDX.
%  IDX may be a double list of indices or a logical vector the same length
%  as the number of switch points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:51 $ 

obj.OpPoints = obj.OpPoints(idx, :);
obj.ModelList = obj.ModelList(idx);
