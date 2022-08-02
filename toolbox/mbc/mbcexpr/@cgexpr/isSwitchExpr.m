function ret = isSwitchExpr(m)
%ISSWITCHEXPR Return true if expression is a switching expression
%
%  RET = ISSWITCHEXPR(OBJ) returns true for switching expression.  These
%  expression types have valid evaluations only at certain input points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:55 $ 

% cgexpr classes need to look down the expression chain to check for any
% switching expressions
pInp = getinputs(m);
if isempty(pInp) 
    ret = false;
else
    % The loop here allows for an early break if a switch expression is
    % found anywhere.
    objInp = info(pInp);
    if iscell(objInp)
        for n = 1:length(pInp)
            ret = isSwitchExpr(objInp{n});
            if ret
                break
            end
        end
    else
        ret = isSwitchExpr(objInp);
    end
end