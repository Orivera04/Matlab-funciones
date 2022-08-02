function T = transpose(A)
%TRANSPOSE Symbolic matrix transpose.
%	TRANSPOSE(A) computes the tranpose of the symbolic or numeric matrix A.
%
%	Example:  transpose(sym('[cos(x), sin(x); -sin(x), cos(x)]'))

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:21 $

if prod(symsize(A)) == 1
   T = A;
else
   T = maple('transpose',A);
end
