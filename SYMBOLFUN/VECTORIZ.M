function F = vectorize(F)
%VECTORIZE Vectorize a symbolic expression.
%	VECTORIZE(F) inserts a '.' before any '^', '*' and '/' in F.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:22 $

l = length(F);
for k = fliplr(find((F=='^') | (F=='*') | (F=='/')))
   F = [F(1:k-1) '.' F(k:l)];
   l = l+1;
end
