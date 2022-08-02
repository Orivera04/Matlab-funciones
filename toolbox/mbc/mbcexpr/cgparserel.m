function ptr = cgparserel(b,blockname,lines, PLIST)
%CGPARSEREL - A CAGE Simulink parse function
%
%  PTR = CGPARSEREL(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:27 $
[handles,newlines] = cgsl2exprsrcblocks(b);
for i = 1:length(handles)
    neweqn{i} = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
end
ptr = xregpointer(cgrelexpr(blockname,neweqn{1},neweqn{2},get_param(b,'operator')));
PLIST.info = [PLIST.info;ptr];
