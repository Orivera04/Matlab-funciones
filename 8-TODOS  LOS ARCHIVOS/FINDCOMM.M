function c = findcomma(s)
%FINDCOMMA Find commas that are not inside of parentheses.
%	FINDCOMMA(S) is the vector of indices of any commas (',')
%	in the string S that are not contained in matching parentheses.
%	Eg. k = findcomma('fun1(x), fun2(x,y), fun3(x), fun4(x,y), fun5')
%	    returns k = [8 19 28 39].  The commas at [16 36] do not count.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:36:55 $

a = find(s == '(');
b = find(s == ')');
c = find(s == ',');
for j = 1:min(length(a),length(b))
   if isempty(c), break, end
   c((c<a(j)) ~= (c<b(j))) = [];
end
