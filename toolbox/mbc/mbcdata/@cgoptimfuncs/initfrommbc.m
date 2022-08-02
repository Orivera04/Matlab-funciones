function obj = initfrommbc(obj)
%INITFROMMBC Set up functions from the list fo builtin MBC ones
%
%  OBJ = INITFROMMBC(OBJ) sets up the functoin list to be the set of
%  optimization functions that are included with MBC.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:56 $ 

obj.FunctionNames = {'mbcOSNBI', 'mbcOSfmincon', 'mbcOSworkedexample'};
obj.FunctionFound = true(size(obj.FunctionNames));