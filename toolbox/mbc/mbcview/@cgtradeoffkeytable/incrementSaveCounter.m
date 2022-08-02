function obj = incrementSaveCounter(obj, datakey)
%INCREMENTSAVECOUNTER Increment the saved counter for a saved point
%
%  OBJ = INCREMENTSAVECOUNTER(OBJ, DATAKEY) increments the counter that
%  tracks the number of times a saved input point has been saved.  DATAKEY
%  may be a vector of keys that should have their counters incremented.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:25 $ 

idx = getIndexFromDatakey(obj, datakey);
idx = idx(idx>0);
if ~isempty(idx)
    obj.DataKeyTable(idx,3) = obj.DataKeyTable(idx,3) + 1;
end
