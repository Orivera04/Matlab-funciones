function [variables, problem, otherVariables] = getvariables(NF,expr);
%GETVARIABLES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:14:48 $

%[tableVariables, problem, otherVariables] = getvariables(NF,expr);

% find the variables (non-constant values) that 
% feed into the LT that also appear in expr.info
% return a problem if the variables in NF do not appear in expr

% get the normaliser pointers
NormX = NF.Xexpr;

% get the pointers in the normalisers
XP = [NormX;NormX.getptrs];

% pick out the variable(s) from the normalisers
xvar = [];
for j = 1:length(XP);
    if isddvariable(XP(j).info) & ~isconstant(XP(j).info)
        xvar = [xvar XP(j)];
    end
end

if nargin == 1
    temp = [xvar];
    dt = double(temp);
    [A,Ind] = unique(temp);
    variables = temp(Ind);
    problem = [];
    othervariables = [];
    return
end

[xvar,SpareX] = cgvardiff(NF.Xexpr,expr);
[notUsed,Spare] = cgvardiff(expr,xvar); % Spare is the variables in expr which are not in LT
lx = length(xvar);
problem = 0;
if lx == 0
    problem = 'One of the table variables does not appear in the model.';
    xvar = [];
    yvar = [];
elseif lx > 1
    problem = 'This table has more than one variable in common with the model.';
end
variables = xvar;

if nargout > 2
    otherVariables = Spare;
end   
