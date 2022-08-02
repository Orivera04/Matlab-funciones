function obj = addDisplayExpression(obj, pDisplay)
%ADDDISPLAYEXPRESSION Add an expression to be displayed in the tradeoff
%
%  OBJ = ADDDISPLAYEXPRESSION(OBJ, pDisplay) adds the pointer to an
%  expression, pDisplay, to the list of pointers to be displayed during the
%  tradeoff.  pDisplay may also be a pointer vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:06 $ 

obj.GraphExpressions = unique([obj.GraphExpressions pDisplay(:)']);

% Update heap copy
xregpointer(obj);
