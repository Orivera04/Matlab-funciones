function ptr = cgparsefunction(b,blockname,lines, PLIST)
%CGPARSEFUNCTION - A CAGE Simulink parse function
%
%  PTR = CGPARSEFUNCTION(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:14 $

[handle,newline] = cgsl2exprsrcblocks(b);
neweqn = cgsl2exprgetprior(handle,'',b,newline, PLIST);
ptr = cgparselookup(b,blockname,neweqn,'NF', PLIST);
