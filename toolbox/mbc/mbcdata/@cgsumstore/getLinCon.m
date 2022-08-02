function [A, B] = getLinCon(sumst)
% GETLINCON Return the linear constraints for the sum optimization
% 
%  [Asum, Bsum] = GETLINCON(SUMST) returns the matrix A and vector B that define
%  the linear constraints for the sum optimization in SUMST. The define the
%  structure of A, first consider the case of r linear constraints for a
%  point optimization. In this case A = [A(1), A(2), ..., A(r)], where A(j)
%  is the  j-th column of A. Furthermore, B = [b(1) ... b(ncon)]', where
%  b(i) is the bound for the i-th linear constraint. The structure of Asum
%  is a sparse block matrix, outlined below
%   
%  [A(1) 0   0  ..  0   | A(2)  0    0   | ... A(r)... ] .. constraints for pt 1 
%  [ 0  A(1) 0  ..  0   |  0   A(2)  0   | ....A(r)... ] .. constraints for pt 2
%                             ..
%  [ 0   0   0  .. A(1) |  0    0   A(2) | ....A(r)... ] .. constraints for pt nN
%
%  where nN is the number of non-zero weighted operating points in the
%  optimization
%
%  Bsum = repmat(B, nN, 1)
%  
%  Smoothness constraints are applied by appending to the A and B matrices.
%
%  See also CGSUMSTORE/GETPOINTCON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:34 $

% standard linear constraints
[A, B] = pgetAB(sumst, 'A', 'B');

% get the optimization store
os = sumst.os;
optim = get(os, 'cgoptim');

% get the constraints
constraints = get(optim, 'constraints');

% look for the constraints that are linear and for a sum optimization
for i = 1:length(constraints)
    if constraints(i).islinear & constraints(i).issum
        [Asmooth, Bsmooth] = getAB(constraints(i).get('conobj'));
        % append sum linear constraints constraints to standard linear
        % constraints
        A = [A; Asmooth];
        B = [B; Bsmooth];
    end
end
