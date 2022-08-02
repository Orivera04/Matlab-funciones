function relockTables(T)
%RELOCKTABLES Reapply size locks to all tables
%
%  RELOCKTABLES(OBJ) re-applies the size lock to every table in the
%  tradeoff.  This methods should not normally need to be used, but it may
%  be of use if table size locks have had to be cleared.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:36:40 $ 

passign(T.Tables, pveceval(T.Tables, @addsizelock, T.ObjectKey));
