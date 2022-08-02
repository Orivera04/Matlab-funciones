function ok = canUnassign(op,fact_i)
% ok = canUnassign(op,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:30 $

% Is one or more of selection assigned?
%   Additionally, check creation
%     - cannot unassign something created from Cage (flag = -1).
%   Cannot unassign if: in group or linked

% If in group, must be created from Cage.

ok = isvalid(op.ptrlist(fact_i)) & ...
    op.created_flag(fact_i)==0 & ...
    ~isvalid(op.linkptrlist(fact_i));

% Something may be linked to this factor. Check this when unassigned.