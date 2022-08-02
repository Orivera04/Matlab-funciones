function out = setname(expr , str)
%SETNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:52:18 $

if ~isa(str , 'char') | isempty(str)
	expr.name = '';
    out = expr;
else
	
	num=double(str);
	if num(1)>=48 & num(1)<=57
		str = ['A',str];
	end
	
	if length(str)>namelengthmax 
		str=str(1:namelengthmax);
        num=num(1:namelengthmax);
	end
	illegal = [32:47 58:64 91:94 96 123:126];
	ind = find(ismember(num,illegal));
	str(ind) = '';
	expr.name = str;
	out = expr;
end
