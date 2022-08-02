function ptr = cgparsemswitch(b,blockname,lines, PLIST)
%CGPARSEMSWITCH - A CAGE Simulink parse function
%
%  PTR = CGPARSEMSWITCH(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:24 $
 
[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = cell( size(handles) );
for i = 1:length(handles)
    neweqn{i} = cgsl2exprgetprior(handles(i),'',b,newlines(i), PLIST);
end
if length(handles)>1
    try
        ud=get_param(b,'userdata');
        ud.info = ud.set('input',neweqn{1},'list',[neweqn{2:end}]);
        ud.info = ud.setname(blockname);
        ptr = ud;
    catch
        ptr = xregpointer(cgmswitchexpr(blockname,neweqn{1},[neweqn{2:end}]));
        PLIST.info = [PLIST.info;ptr];
    end
else
    error('Not enough inputs to multi port switch block')
    return
end