function f = symvars(f,y,x)
%SYMVARS Symbolic variable substitution.
%	F = SYMVARS(F,Y,X) changes the symbolic variable in F to Y from X.
%	This does the same thing as SUBS(F,Y,SYMVAR(F)) without using Maple.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:21 $

f = [' ' f ' '];
k = find(f == x);
k = k(find(~isletter(f(k-1)) & ~isletter(f(k+1))));
f(k) = y * ones(1,length(k));
f = setstr(f(2:length(f)-1));
