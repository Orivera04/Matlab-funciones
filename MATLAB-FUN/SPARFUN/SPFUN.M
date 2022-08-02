function f = spfun(fun,s)
%SPFUN 	Apply a function only to the nonzero entries.
%	F = SPFUN('fun',S) evaluates fun(s) on the nonzero elements of S.
%	e.g. F = SPFUN('exp',S) has the same sparsity pattern as S
%	(except for underflow), whereas EXP(S) has 1's where S has 0's.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[i,j,x] = find(s);
[m,n] = size(s);
f = sparse(i,j,feval(fun,x),m,n);

