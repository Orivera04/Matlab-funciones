function ptr = cgparseifexpr(b,blockname,lines,PLIST)	
%CGPARSEIFEXPR - A CAGE Simulink parse function
%
%  PTR = CGPARSEIFEXPR(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:17 $

ptr = cgsl2exprcheckname(blockname, PLIST);
if ~isvalid(ptr)
    neweqn=[];
    [handles,newlines] = cgsl2exprsrcblocks(b);
    for i = 1:length(handles)
        p = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i),PLIST);
        neweqn = [neweqn {p}];
    end
    ptr = xregpointer(cgifexpr(blockname,neweqn{1},neweqn{2},neweqn{3},neweqn{4}));
    PLIST.info = [PLIST.info;ptr];
end
