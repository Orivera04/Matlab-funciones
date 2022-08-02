function [variables, problem, othervariables]= getvariables(LT,expr)
% variables = getvariables(LT,expr)
% variables = getvariables(LT) - return the variables in LT.
% find the variables (non-constant values) that 
% feed into the LT and also appear in expr.info
% if nargout >2 also return the variables in expr.info but not in LT
% 
% return a problem if the variables in LT do not appear in expr

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:11:42 $


% For this to work, the model and each normaliser have to share a variable in common.
if nargin == 1
    % get the normaliser pointers
    NormX = LT.Xexpr;
    NormY = LT.Yexpr;
    
    % get the pointers in the normalisers
    XP = NormX.getptrs;
    YP = NormY.getptrs;
    
    % pick out the variable(s) from the normalisers
    xvar = [];
    for j = 1:length(XP);
        if isddvariable(XP(j).info) & ~isconstant(XP(j).info)
            xvar = [xvar XP(j)];
        end
    end
    yvar = [];
    for j = 1:length(YP)
        if isddvariable(YP(j).info) & ~isconstant(YP(j).info)
            yvar = [yvar YP(j)];
        end
    end
    
    temp = [xvar  yvar]';
    dt = double(temp);
    [A,Ind] = unique(dt);
    variables = temp(ind);
    problem = [];
    othervariables = [];
else
    %comparison with an input expr
    [xvar,SpareX] = cgvardiff(LT.Xexpr,expr);
    [yvar,SpareY] = cgvardiff(LT.Yexpr,expr);
    [notUsed,Spare] = cgvardiff(expr,[xvar yvar]); % Spare is the variables in expr which are not in LT
    lx = length(xvar);ly = length(yvar);
    problem = 0;
    if lx == 0 | ly == 0
        problem = 'One of the table variables does not appear in the model.';
        xvar = [];
        yvar = [];
    elseif lx > 1  | ly > 1
        problem = 'This table has more than two variables in common with the model.';
    end
    variables = [xvar yvar];
 
    if nargout > 2
        % find the other variables
        othervariables = Spare;
    end   
end