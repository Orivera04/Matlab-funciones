function N = cgnumindependentvars(pVar)
%CGNUMINDEPENDENTVARS Return the number of independent variables in a list
%
%  N = CGNUMINDEPENDENTVARS(PVAR) returns the total number of independent
%  variables in the list PVAR.  For example, if PVAR contains a polint to a
%  formula f = x+K, a variable x and a constant T, the number of
%  independent variables is only 2 because f and x cannot be simultaneously
%  set to different values.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:10 $ 

if length(pVar)==1
    N = 1;
    return
end

objVar = info(pVar);
for n = 1:length(pVar)
    if issymvalue(objVar{n})
        % replace with reference to the input variable
        pVar(n) = getvariable(objVar{n});
    end
end
N = length(unique(pVar));