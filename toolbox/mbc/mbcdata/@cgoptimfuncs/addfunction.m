function [obj, OK] = addfunction(obj, fcn)
%ADDFUNCTION Add a function to the list
%
%  OBJ = ADDFUNCTION(OBJ, FCN) adds the function FCN to the list of currently
%  available ones for optimization.  The function will not be added if a
%  function with that name already exists and in this case the OK flag will
%  return false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:49 $ 

% Check the function isn't already there
OK = ~any(strcmp(fcn , obj.FunctionNames));

if OK
    obj.FunctionNames(end+1) = {fcn};
    obj.FunctionFound(end+1) = pfindfunction(fcn);
end