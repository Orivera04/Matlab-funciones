function ptr = cgparselookuptwo(b,blockname,lines, PLIST)
%CGPARSELOOKUPTWO - A CAGE Simulink parse function
%
%  PTR = CGPARSELOOKUPTWO(blockHandle,blockName,lines, pPointerList)
%  Handles all types of lookup block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:21 $

[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = [cgsl2exprgetprior(handles(1),'',b,newlines(1), PLIST) cgsl2exprgetprior(handles(2),'',b,newlines(2), PLIST)];

ptr = cgparselookup(b,blockname,neweqn,'L2', PLIST);

