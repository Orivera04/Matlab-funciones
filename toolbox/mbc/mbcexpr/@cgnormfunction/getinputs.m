function ptrs = getinputs(LT)
%GETINPUTS Return inputs to expression
%
%  PTRS = GETINPUTS(LT) returns the pointers that are feeding into the
%  expression object LT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:14:44 $ 

ptrs = null(xregpointer,1);
if ~isempty(LT.Xexpr)
    ptrs(1) = LT.Xexpr;
end