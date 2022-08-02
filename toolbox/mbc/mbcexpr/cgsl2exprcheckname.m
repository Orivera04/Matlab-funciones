function p = cgsl2exprCheckName(name, PLIST)
%CGSL2EXPRCHECKNAME - Check name of this block against list found so far
%
%  OUT = CGSL2EXPRCHECKNAME(NAME, pPointerList)
%  OUT - ptr to any object found to match NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:35 $ 
list = PLIST.info;
p = xregpointer;
for i=1:length(list)
	if strcmp(name, list(i).getname)
		p = list(i);
		break
	end
end