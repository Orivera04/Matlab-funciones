function p = symrcm(S)
%SYMRCM	Reverse Cuthill-McKee ordering.
%	p = SYMRCM(S) returns a permutation p such that S(p,p) 
%	tends to have smaller profile than S.  This is a 
%	good preordering for LU or Cholesky factorization 
%	of matrices that come from "long, skinny" problems.
%	It works for both symmetric and asymmetric S.
%
%	See also SYMMMD, COLMMD, COLPERM.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

p = sparsfun('symrcm',S|(S'));
