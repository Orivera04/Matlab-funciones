function ptr = cgparsegain(b,blockname,lines, PLIST)
%CGPARSEGAIN - A CAGE Simulink parse function
%
%  PTR = CGPARSEGAIN(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:15 $


[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = cgsl2exprgetprior(handles,'',b,newlines, PLIST);

ptr = cgsl2exprcheckname(blockname, PLIST);
if isnull(ptr)
    name = blockname;
else
    % we need to give cgconstants unique names - we'll prepend this with
    % the parent system name
    parentName = get_param(get_param(b, 'Parent'), 'Name');
    name = sprintf( '%s_%s', parentName, blockname );
end

% always make a constant start equal to 1
ptr1 = xregpointer(cgconstant(name,1));
ptr = xregpointer(cgdivexpr('Product',[neweqn ptr1]));
PLIST.info = [PLIST.info; ptr1; ptr];

