function restoreTableSizeLocks(obj)
%RESTORETABLESIZELOCKS Restore all table size locks to the correct state
%
%  RESTORETABLESIZELOCKS(OBJ) clears all table size locks and then
%  reapplies them by asking all existing objects that use size locking to
%  reapply their locks.  This method can be used if stale locks are
%  inadvertantly left on a table and are preventing further table use.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:53 $ 

% Get all tables and clear their locks
pT = gettables(obj);
passign(pT, pveceval(pT, @forcesizeunlock));

% Get all tradeoffs and tell them to reapply locks
toffObj = filterbytype(obj, cgtypes.cgtradeofftype);
for n = 1:length(toffObj)
    relockTables(toffObj{n});
end
