function portptrs = getdditems(expr)
%GETINPORTS Return the variable dictionary item ports of an expression
%
%  PTRS = GETDDITEMS(EXPR) returns the expression sources that are variable
%  dictionary items.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:44 $ 

portptrs = recursivefind(expr, @i_isddvariable);


function ret = i_isddvariable(obj)
ret = logical(isddvariable(obj));