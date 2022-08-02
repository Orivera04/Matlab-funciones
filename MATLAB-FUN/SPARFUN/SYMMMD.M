function p = symmmd(S)
%SYMMMD	Symmetric minimum degree.
%	p = SYMMMD(S), for a symmetric positive definite matrix S,
%	returns a permutation p such that S(p,p) tends to have a
%	sparser Cholesky factor than S.  Sometimes SYMMMD works well
%	for symmetric indefinite matrices too.
%
%	See also COLMMD, COLPERM, SYMRCM.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

p = sparsfun('symmmd',S);
[ignore,q] = sparsfun('symetree',S(p,p));
p = p(q);
