function p = colperm(S)
%COLPERM	Order columns based on nonzero count.
%	p = COLPERM(S) generate a permutation that reorders the
%	columns of the sparse (or full) matrix S in nondecreasing
%	order of nonzero count.  Useful as a preordering for LU 
%	factorization: lu(S(:,p)).
%	Not the best ordering in the world, but it's fast to 
%	compute, it does a pretty good job, and it shows that 
%	we, too, can write tricky one-liners.
%
%	See also COLMMD, SYMMMD, SYMRCM.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[i,j] = find(S);
[ignore,p] = sort(diff(find(diff([0 j' inf]))));
