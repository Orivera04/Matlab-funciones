function obj = locatefunctions(obj)
%LOCATEFUNCTIONS Check whether each function can be found
%
%  OBJ = LOCATEFUNCTIONS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:58 $ 

for n = 1:length(obj.FunctionNames)
    obj.FunctionFound(n) = pfindfunction(obj.FunctionNames{n});
end