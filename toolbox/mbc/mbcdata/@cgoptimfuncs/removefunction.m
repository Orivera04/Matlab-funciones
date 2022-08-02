function obj = removefunction(obj, fcn)
%REMOVEFUNCTION Remove an optimization function
%
%  OBJ = REMOVEFUNCTION(OBJ, FCN) removes the function FCN from the list of
%  available ones for optimization.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:54:02 $ 

remidx = strcmp(fcn , obj.FunctionNames);
if any(remidx)
    remidx = ~remidx;
    obj.FunctionNames = obj.FunctionNames(remidx);
    obj.FunctionFound = obj.FunctionFound(remidx);
end