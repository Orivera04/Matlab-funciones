function obj = removeFromExcludedData(obj, guidToRemove)
%removeFromExcludedData A short description of the function
%
%  OBJ = removeFromExcludedData(OBJ, GUIDARRAY)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:36 $ 

obj = modifyExcludedData(obj, [], guidToRemove);