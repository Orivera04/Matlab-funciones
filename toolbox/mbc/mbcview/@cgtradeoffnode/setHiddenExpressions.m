function obj = setHiddenExpressions(obj, pExpr)
%SETHIDDENEXPRESSIONS Set the list of expressions that will not be plotted
%
%  OBJ = SETHIDDENEXPRESSIONS(OBJ, PEXPR) sets the list of expressions that
%  the user has chosen not to have plotted.  This list may contain inputs
%  and outputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:42 $ 

obj.GraphHideExpressions = unique(pExpr(:).');

% Update the heap copy
xregpointer(obj);
