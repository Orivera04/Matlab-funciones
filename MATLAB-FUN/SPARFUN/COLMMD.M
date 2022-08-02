function p = colmmd(S)
%COLMMD	Column minimum degree.
%	p = COLMMD(S).  Column minimum degree ordering of S.
%	For an asymmetric matrix S, this returns a column permutation p
%	such that S(:,p) tends to have sparser LU factors than S.
%
%	See also SYMMMD, SYMRCM, COLPERM.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

p = sparsfun('colmmd',S);
[ignore,q] = sparsfun('coletree',S(:,p));
p = p(q);
