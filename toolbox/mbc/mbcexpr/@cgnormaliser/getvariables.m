function [tableVariables, problem, otherVariables] = getvariables(Norm,expr);
%GETVARIABLES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:58 $

%[tableVariables, problem, otherVariables] = getvariables(Norm,expr);

% find the variables (non-constant values) that 
% feed into the LT that also appear in expr.info
% return a problem if the variables in Norm do not appear in expr


      
% get the pointers in the normalisers
XP = getptrs(Norm);
    
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
    tableVariables = temp(Ind);
    problem = [];
    othervariables = [];
    return
end

% get the pointers to variables in the expression
exprPtrs = expr.getptrs;
varExpr = [];
for j = 1:length(exprPtrs)
   if isddvariable(exprPtrs(j).info) & ~isconstant(exprPtrs(j).info)
      varExpr = [varExpr exprPtrs(j)];
   end
end

dv = double(varExpr); % convert the pointers to doubles
[junk,indices] = unique(dv); % find the unique pointers 

% unique valptrs in the expression
varExpr = varExpr(indices);
      
dx = double(xvar);
      
dm = double(varExpr);
      
[Ax,ix,jx] = intersect(dx,dm);

if length(Ax) == 0;
   problem = 'The table variable does not appear in the model.';
   tableVariables = [];
elseif length(Ax) >1
   tableVariables = xvar(ix);
   problem = 'This table has more than one variable in common with the model.';
elseif ~isequal(length(dx),1);
   problem = 'The axis does not have exactly one variable feeding into it. ';
   tableVariables = xvar;
else
   tableVariables = xvar(ix);
   problem = 0;
end
  
if nargout > 2
   % find the other variables
   [dother, ind] = setdiff(dm, dx);
   otherVariables = varExpr(ind);
end   
      