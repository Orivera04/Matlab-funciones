function ptr = cgparseconstant(b,blockname,lines,PLIST)
%CGPARSECONSTANT - A CAGE Simulink parse function
%
%  PTR = CGPARSECONSTANT(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:11 $

if strcmp(get_param(b,'BlockType'),'Constant')
	val = get_param(b,'value');
else
	val = get_param(b,'constant');
end
if any(isletter(val))
	% constant name is in parameter
	blockname = val;
end
try
    ud=get_param(b,'userdata');
	ud.info = ud.setname(blockname);
	ptr = ud;
catch
	ptr = cgsl2exprcheckname(blockname, PLIST);
    if isnull(ptr)
        name = blockname;
    else
        % we need to give cgconstants unique names - we'll prepend this with
        % the parent system name
        parentName = get_param(get_param(b, 'Parent'), 'Name');
        name = sprintf( '%s_%s', parentName, blockname );
    end
    ptr = xregpointer(cgconstant(name,1));
    ptr.info = ptr.set('precision',cgprecfloat);
end
PLIST.info = [PLIST.info;ptr];
