function s = nonzeros(S);
%NONZEROS Nonzero elements.
%	NONZEROS(S) is a full column vector of the nonzeros in S.
%	This gives the s, but not the i and j, from [i,j,s] = find(S).
%
%	See also NNZ, FIND.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

s = sparsfun('nzvals',S);
