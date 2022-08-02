function INLINE_OBJ= inline(s);
% SYM/INLINE converts a sym object into a vectorized inline object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 06:48:10 $

if prod(size(s))>1
	% handles symbolic arrays
	str= '[';
	for i=1:size(s,1)
		for j= 1:size(s,2)
			str= [str s(i,j).s,' '];
		end
		% end of row
		str= [str,';'];
	end
	% remove last semicolon and end array build
	str= [str(1:end-1),']'];
else
	% scalar case
	str = s.s;
end

obj= inline(str);
INLINE_OBJ= vectorize(obj);
