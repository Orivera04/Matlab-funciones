function portptrs = getinports(expr)
%GETINPORTS Return the input ports of an expression
%
%  PTRS = GETINPORTS(EXPR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:08:45 $ 

portptrs = recursivefind(expr, @isinport);