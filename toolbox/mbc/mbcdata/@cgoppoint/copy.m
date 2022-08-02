function newop = copy(op,changes);
% [newop] = copy(op,changes)
%  op is cgoppoint to copy
%  changes indicate where new exprs have been created; matrix of [old new]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:37 $

newop = op;
newop = mapptr(newop,changes(:,1),changes(:,2));