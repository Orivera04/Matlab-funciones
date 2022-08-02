function [fcn, status] = getfunctions(obj)
%GETFUNCTIONS Return list of registered functions
%
%  [FCNLIST, FCNSTATUS] = GETFUNCTIONS(OBJ) returns a cell arry of the
%  registered functions and a logical vector indicating their current
%  "Found" status.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:54 $ 

fcn = obj.FunctionNames;
status = obj.FunctionFound;