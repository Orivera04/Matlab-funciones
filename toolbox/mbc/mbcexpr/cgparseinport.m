function ptr = cgparseinport(b,blockname,lines,PLIST)	
%CGPARSEINPORT - A CAGE Simulink parse function
%
%  PTR = CGPARSEINPORT(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/02/09 07:17:18 $
global CGSL2EXPR_STARTLEVEL

if (get_param(get_param(b,'parent'),'handle') ~= CGSL2EXPR_STARTLEVEL)
    port_num = str2double(get_param(b,'port'));
    [handles,newlines] = cgsl2exprsrcblocks(get_param(b,'parent'));
    neweqn = cgsl2exprgetprior(handles(port_num),'',get_param(b,'parent'),newlines(port_num),PLIST);
    ptr = neweqn;
else
    try
        ud=get_param(b,'userdata');
        ud.info = ud.setname(blockname);
        ptr = ud;
    catch
        DD = get(cgbrowser, 'DataDictionary');
        [DD.info,ptr] = add(DD.info,blockname);
    end  
end


