function C = symdiv(A,B)
%SYMDIV	Symbolic division.
%	SYMDIV(A,B), for symbolic expressions or matrices A and B,
%	computes A / B .
%
%	Examples:
%
%	symdiv('2*cos(t)+6',3) returns 2/3*cos(t)+2.
%	
%	If
%	   A =
%	   [   2, a + 3/2]
%	   [ 7/6, a/2 + 1]
% 
%	   B =
%	   [   1, 1/2]
%	   [ 1/2, 1/3]
%
%	then symdiv(A,B) returns 
%	   [  -1-6*a, 6+12*a]
%	   [-4/3-3*a,  5+6*a]
%
%	See also SYMOP, SYMMUL, SYMPOW, INVERSE.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/24 22:37:16 $

C = symop(A,'/',B);
