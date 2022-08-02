function ptrs = getinputs(LT)
%GETINPUTS Return inputs to expression
%
%  PTRS = GETINPUTS(LT) returns the pointers that are feeding into the
%  expression object LT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:11:38 $ 

ptrs = null(xregpointer,1,2);
if ~isempty(LT.Xexpr)
    ptrs(2) = LT.Xexpr;
end
if ~isempty(LT.Yexpr)
    ptrs(1) = LT.Yexpr;
end