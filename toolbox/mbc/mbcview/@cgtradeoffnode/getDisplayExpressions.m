function pDisplay = getDisplayExpressions(obj)
%GETDISPLAYEXPRESSIONS Return list of display expressions
%
%  PDISPLAY = GETDISPLAYEXPRESSIONS(OBJ) returns a pointer vector of
%  pointers to all expressions that have been added to the list of
%  additional items being displayed in the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:28 $ 

pDisplay = obj.GraphExpressions;
