function obj = removeDisplayExpression(obj, pDisplay)
%REMOVEDISPLAYEXPRESSION Remove display expressions from the tradeoff
%
%  OBJ = REMOVEDISPLAYEXPRESSION(OBJ, pDisplay) removes the expression
%  pDisplay from the list of those being displayed.  If pDisplay is a
%  vector they will all be removed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:36 $ 

obj.GraphExpressions = setdiff(obj.GraphExpressions, pDisplay);

% Update the heap copy
xregpointer(obj);
