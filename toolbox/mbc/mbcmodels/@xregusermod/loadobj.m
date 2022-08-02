function U= loadobj(U);
%XREGUSERMOD/LOADOBJ convert name to function handle

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:01:22 $


U.funcName= str2func(U.funcName);