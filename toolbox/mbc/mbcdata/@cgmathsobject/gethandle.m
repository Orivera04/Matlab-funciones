function out = gethandle(x,str)
%GETHANDLE
%
%  H = GETHANDLE(OBJ, STR) returns a function handle to the named routine.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:50:01 $

%  Gets the handle to a function held inside the private directory
out = str2func(str);
