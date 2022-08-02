function x0 = getInitVals(sumst)
%GETINITVALS Return the initial free variable values 
%
%  X0 = GETINITVALS(SUMST) interrogates the optimization and returns the
%  initial values of the free variables for a sum optimization. X0 is a
%  column vector with the following structure X0 = [F1_NP1; F1_NP2; ...;
%  F2_NP1; F2_NP2; ...],  where NPj is the j-th non-zero point in the data
%  set (for a definition of non-zero point, see the extra comments in
%  CGSUMSTORE) and Fi is the i-th free variable selected by the user.
%
%  See also CGSUMSTORE/GETBOUNDS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:33 $

os = sumst.os;
x0 = getInitFreeVal(os);
nzt = getNonZeroWtPts(sumst);
x0 = x0(nzt, :);
x0 = x0(:);


