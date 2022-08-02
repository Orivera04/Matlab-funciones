function idx = findfunction(obj, fcn)
%FINDFUNCTION Return the index of a function in the current list
%
%  IDX = FINDFUNCTION(OBJ, FCN) returns the index in the registered list of
%  the function FCN.  If FCN is not in the list, IDX will be empty.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:53 $ 

idx = strmatch(fcn, obj.FunctionNames, 'exact');