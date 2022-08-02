function pExpr = getHiddenExpressions(obj)
%GETHIDDENEXPRESSIONS Return list of expressions that will not be plotted
%
%  GETHIDDENEXPRESSIONS(OBJ) returns the list of expressions that the user
%  has chosen not to have plotted.  This list contains inputs and outputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:33 $ 

pExpr = obj.GraphHideExpressions;
