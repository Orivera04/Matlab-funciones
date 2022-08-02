function ptr = cgparseminmax(b,blockname,lines, PLIST)
%CGPARSEMINMAX - A CAGE Simulink parse function
%
%  PTR = CGPARSEMINMAX(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:23 $

[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn=[];
for i = 1:length(handles)
    neweqn = [neweqn, {cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST)}];
end
type = strcmp(get_param(b,'function'),'min');
try
    ud=get_param(b,'userdata');
    ud.info = ud.set('ptrlist',[neweqn{:}],'type',type);
    ud.info = ud.setname(blockname);
    ptr = ud;
catch
    ptr = xregpointer(cgminmaxexpr(blockname,[neweqn{:}],type));
    PLIST.info = [PLIST.info;ptr];
    set_param(b,'userdata',ptr);
end