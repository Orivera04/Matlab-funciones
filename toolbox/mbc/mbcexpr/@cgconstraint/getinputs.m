function ptrs = getinputs(obj)
%GETINPUTS Return input pointers for expression
%
%  PTRS = GETINPUTS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 07:09:16 $ 

% Inputs to constraints are union of expression inputs and any model
% constraint inputs
if ismodel(obj)
    P = getparams(obj.conobj);
    if ~isempty(P.modptr) & isvalid(P.modptr)
        ptrs = getinputs(P.modptr.info);
    else
        ptrs = [];
    end
else
    ptrs = getinputs(obj.cgexpr);
end