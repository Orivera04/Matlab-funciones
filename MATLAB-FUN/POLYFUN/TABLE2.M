function z = table2(tab,x0,y0)
%TABLE2	Two-dimensional table look-up.
%	Z = TABLE2(TAB,X0,Y0) returns a linearly interpolated
%	intersection from table TAB, looking up X0 in the first
%	column and Y0 in the first row of TAB.  
%
%	See also INTERP3, INTERP4, INTERP5, TABLE1.

%	Paul Travers 7-14-87
%	Revised JNL 3-15-89
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if (nargin ~= 3), error('Must be used with three input arguments.'), end

[m,n] = size(tab);
a = table1(tab(2:m,:),x0);
tab2 = [tab(1,2:n).' a.'];
z = table1(tab2,y0).';
