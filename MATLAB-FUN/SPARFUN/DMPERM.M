function [p,q,r,s] = dmperm(A)
%DMPERM	Dulmage-Mendelsohn decomposition of matrix A.
%
%	p = DMPERM(A) returns a maximum matching; if A has full 
%	column rank then A(p,:) is square with nonzero diagonal.
%
%	[p,q,r,s] = DMPERM(A) returns permutations to put A(p,q) 
%	in block upper triangular form:
%	For square full-rank A, A(p,q) has nonzero diagonal
%	and the i'th strong Hall component is block (bi,bi) 
%	of A(p,q), where bi = r(i):r(i+1)-1.
%	For general rectangular A, the i'th strong Hall 
%	component is block (r(i):r(i+1)-1, s(i):s(i+1)-1).
%
%	See also SRANK.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargout <= 1,
    p = sparsfun('dmperm',A);
elseif nargout == 2,
    [p,q] = sparsfun('dmperm',A);
elseif nargout == 3,
    [p,q,r] = sparsfun('dmperm',A);
else
    [p,q,r,s] = sparsfun('dmperm',A);
end;
