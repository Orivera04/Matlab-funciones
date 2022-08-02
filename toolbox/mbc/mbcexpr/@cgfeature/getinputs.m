function ptrs = getinputs(obj)
%GETINPUTS Return input pointers for expression
%
%  PTRS = GETINPUTS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:10:37 $ 

% The input for a feature is the equation
ptrs = obj.eqexpr;