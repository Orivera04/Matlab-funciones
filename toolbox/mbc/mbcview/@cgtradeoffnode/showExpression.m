function obj = showExpression(obj, pExpr)
%SHOWEXPRESSION Removes expression from list of ones that are not plotted
%
%  OBJ = SHOWEXPRESSION(OBJ, PEXPR) removes PEXPR from the list of
%  expressions that will not be plotted.  PEXPR is a pointer (or pointer
%  vector) to either an input or output expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:46 $ 

obj.GraphHideExpressions = setdiff(obj.GraphHideExpressions, pExpr);

% Update the heap copy
xregpointer(obj);
