function obj = mapptr(obj,RefMap)
%MAPPTR Remap pointers in object
%
%  OBJ = MAPPTR(OBJ, REFMAP) remaps pointers within the object.  This is
%  typically called during a load operation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:16:11 $

obj.tablePtrs = mapptr(obj.tablePtrs,RefMap);

for i = 1:length(obj.fillPtrs)
    if iscell(obj.fillPtrs{i})
        for ii = 1:size(obj.fillPtrs{i},1)
            for jj = 1:size(obj.fillPtrs{i},2)
                if ~isempty(obj.fillPtrs{i}{ii,jj})
                    obj.fillPtrs{i}{ii,jj} = mapptr(obj.fillPtrs{i}{ii,jj},RefMap);
                end
            end
        end
    else
        obj.fillPtrs{i} = mapptr(obj.fillPtrs{i},RefMap);
    end
end

obj.opPoint = mapptr(obj.opPoint,RefMap);

if ~isempty(obj.viewStore)
    obj.viewStore = mapptr(obj.viewStore,RefMap);
end

% remap hidden list pointers
if ~isempty(obj.hiddenFactors)
    obj.hiddenFactors = mapptr(obj.hiddenFactors,RefMap);
end
if ~isempty(obj.hiddenModels)
    obj.hiddenModels = mapptr(obj.hiddenModels,RefMap);
end
