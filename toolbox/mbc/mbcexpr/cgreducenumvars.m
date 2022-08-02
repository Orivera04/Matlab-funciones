function pReduced = cgreducenumvars(pVar)
%CGREDUCENUMVARS Reduce variable list to minimum length
%
%  PREDUCED = CGREDUCENUMVARS(PVAR) returns the independent set of variable
%  items from PVAR.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:17:32 $ 

pReduced = assign(xregpointer, []);
for n = 1:length(pVar)
    thisptr = pVar(n);
    if thisptr.issymvalue 
        pVar(n) = thisptr.getvariable;
    end
    if ~ismember(pVar(n), pVar(1:n-1))
        pReduced = [pReduced, thisptr];
    end
end