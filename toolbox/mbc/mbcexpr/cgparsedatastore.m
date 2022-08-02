function ptr = cgparsedatastore(b,blockname,lines, PLIST)	
%CGPARSEDATASTORE - A CAGE Simulink parse function
%
%  PTR = CGPARSEDATASTORE(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/02/09 07:17:12 $
global CGSL2EXPR_STARTLEVEL

dsname = get_param(b,'datastorename');

src = find_system(CGSL2EXPR_STARTLEVEL,...
    'findall','on',...
    'LookUnderMasks','all',...
    'followlinks','on',...
    'blocktype','DataStoreWrite',...
    'datastorename',dsname);

if isempty(src)
    DD = get(cgbrowser, 'DataDictionary');
    [DD.info,ptr] = add(DD.info,dsname);
else
    [handles,newlines] = cgsl2exprsrcblocks(src(1));
    ptr = cgsl2exprgetprior(handles,'',b,newlines, PLIST);
end
