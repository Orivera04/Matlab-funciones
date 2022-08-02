function V = values_regression1(X,Y,BPx)
%VALUES_REGRESSION1
%
% V = VALUES_REGRESSION(X,Y,BPx) produces a values vector V which when used
% with breakpoints BPx  in a look up table provides the closest match to a
% function trying to achieve
%
%               F(X) = Y
%
% X and Y should be column vectors of the same length.
%
% This algorithm employs a linear regression argument to fill out the
% table. If the table has breakpoints BPx (length n) in the x, then the
% output of the table at a point X is:
%
% $$ (1)            \Sigma_{i=1}^{i=n} a_{i}*\phi_{i}(X).   $$ (look at it in LaTeX)
%
% Where $ \phi_{ij}(X,Y) $ is the triangular function over the line segment
% defined by $ BPx{i-1} < x < BPx_{i+1} $, which has an apex of height 1
% located at $ x = BPx_{i}$. The equation (1)  is linear in the $ a_{i} $,
% so on setting up the requisite regression matrices we can utilise linear
% regression theory to get the optimal set of values.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:25:53 $

wrn = warning('off');

% Lengths of inputs
N = length(BPx); XL = length(X);

% Initialise matrices
Xhat = sparse(XL,N);

for I = 1:N
    tempval = zeros(N,1);
    tempval(I) = 1;
    % X contribution towards regression matrix (phi contribution from X)
    Xhat(:,I) = linear1(BPx,tempval,X);
end

V = Xhat\Y;

warning (wrn);
