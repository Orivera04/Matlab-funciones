function ptr = cgparsesf(b,blockname,lines, PLIST)	
%CGPARSESF - A CAGE Simulink parse function
%
%  PTR = CGPARSESF(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/02/09 07:17:29 $
ptr = [];
port = get_param(lines,'srcporthandle');
blockname = get_param(port,'name');
if isempty(blockname)
    blockname = [get_param(get_param(port,'parent'),'name'),'Port',num2str(get_param(port,'PortNumber'))];
end
blockname = strrep(blockname,' ','_');
blockname = strrep(blockname,char(10),'');

DD = get(cgbrowser, 'DataDictionary');
[DD.info,ptr] = add(DD.info,blockname);