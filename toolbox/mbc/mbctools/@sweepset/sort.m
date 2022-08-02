function map = sort(map)
% SWEEPSET/SORT sorts sweepset into alphabetical order on variable name

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:36 $


% ------------------------------------------------
% Sort variable list into alphabetical name order.
% ------------------------------------------------
[temp2, newVarIndex] = sort({map.var.name});
% rearrange map.var 
S = substruct('()', {':', newVarIndex});
map = subsref(map, S);