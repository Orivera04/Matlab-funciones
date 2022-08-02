function obj = hideExpression(obj, pExpr)
%HIDEEXPRESSION Prevent an expression from being plotted
%
%  OBJ = HIDEEXPRESSION(OBJ, PEXPR) adds PEXPR to the list of expressions
%  that will not be plotted.  PEXPR is a pointer (or pointer vector) to
%  either an input or output expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:50 $ 

obj.GraphHideExpressions = unique([obj.GraphHideExpressions, pExpr(:)']);

% Update the heap copy
xregpointer(obj);
