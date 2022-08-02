function ptr = cgparselookupnd(b,blockname,lines, PLIST)
% - A CAGE Simulink parse function
%
%  PTR = cgparselookupnd(blockHandle,blockName,lines, pPointerList)
%  Handles all types of N-D lookup block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:20 $
[handles,newlines] = cgsl2exprsrcblocks(b);
if length(handles)==1
    neweqn = cgsl2exprgetprior(handles(1),'',b,newlines(1),PLIST);
    ptr = cgparselookup(b,blockname,neweqn,'L1', PLIST);
elseif length(handles)==2
    neweqn = [cgsl2exprgetprior(handles(1),'',b,newlines(1), PLIST) cgsl2exprgetprior(handles(2),'',b,newlines(2), PLIST)];
    ptr = cgparselookup(b,blockname,neweqn,'L2', PLIST);
else
    error('Lookups can only be 1 or 2D');
end

