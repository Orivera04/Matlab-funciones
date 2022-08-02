function OldValue = getbad(Map,Var,RecInd)
%Takes a variable and a vector of record numbers, and returns the old value.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:22 $

VarInd = find(Map,Var);

OldValue = Map.baddata(RecInd,VarInd);