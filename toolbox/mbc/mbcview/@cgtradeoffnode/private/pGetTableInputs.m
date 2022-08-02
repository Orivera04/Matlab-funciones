function pT = pGetTableInputs(obj)
%PGETTABLEINPUTS Return pointers to inputs to the tables
%
%  P_INPUTS = PGETTABLEINPUTS(OBJ) returns pointers to the inputs to the
%  tables in the tradeoff.  This may be empty if there are no tables in the
%  tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:33 $ 

if isempty(obj.Tables)
    pT = null(xregpointer,0);
else
    pT = obj.Tables(1).getinportperaxis;
end
