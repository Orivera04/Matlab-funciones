function obj = addToExcludedData(obj, guidsToAdd)
%addToExcludedData A short description of the function
%
%  OBJ = addToExcludedData(OBJ, GUIDARRAY)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:11 $ 

obj = modifyExcludedData(obj, guidsToAdd, []);
