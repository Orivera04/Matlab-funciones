function p = randperm(n);
%RANDPERM Random permutation vector.
%	RANDPERM(n) is a random permutation of the integers from 1 to n.
%	For example, RANDPERM(6) might be [2 4 5 6 1 3].
%	
%	Note that RANDPERM calls RAND and therefore changes RAND's
%	seed value.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[ignore,p] = sort(rand(1,n));
