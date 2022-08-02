function ptrs = getinputs(obj)
%GETINPUTS Return inputs to expression
%
%  PTRS = GETINPUTS(OBJ) returns the pointers that are feeding into the
%  expression object OBJ.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:29 $ 

ptrs = obj.EquationPointers;