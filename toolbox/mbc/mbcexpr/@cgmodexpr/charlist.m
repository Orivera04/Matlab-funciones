function str = charlist(mod)
%CHARLIST cgmodexpr charlist method
%
%  S = CHARLIST(M) returns a recursive string describing this expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:58 $

if isempty(mod)
    str = '';
else
    str = [getname(mod),'{'];
    inputs = getinputs(mod);
    for i=1:length(inputs)
        L = inputs(i);
        if isvalid(L)
            str=[str L.charlist ','];
        else
            str=[str ' ,'];
        end
    end
    str=[str(1:end-1) '}'];
end