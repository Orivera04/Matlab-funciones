function [V,mask,varargout] = values_regression2(X,Y,Z,BPx,BPy)
%VALUES_REGRESSION2

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:34 $

% V = VALUES_REGRESSION2(X,Y,Z,BPx,BPy) produces a values matrix V which when used with breakpoints BPx and BPy
% in a look up table provides the closest match to a function trying to achieve
%
%               F(X,Y) = Z
%
% X, Y and Z should be column vectors of the same length. 
%
% This algorithm employs a linear regression argument to fill out the table. If the table has breakpoints
% BPx (length n) in the x direction and BPy (length m) in the y direction, then the output of the table at a 
% point (X,Y)is:
%
% $$ (1)            \Sigma_{i=1, }^{i=n, }_{j=1}^{j=m} a_{ij}*\phi_{ij}(X,Y).   $$ (look at it in LaTeX) 
% 
% Where $ \phi_{ij}(X,Y) $ is the function that is a rectangular based pyramid over the rectangle defined by
% $ BPx{i-1} < x < BPx_{i+1} $ and $ BPy_{j-1} < y < BPy_{j+1} $, which has an apex of height 1 located at 
% $ (BPx_{i},BPy_{j}) $. The equation (1) is linear in the $ a_{ij} $, so on setting up the requisite regression
% matrices we can utilise linear regression theory to get the optimal set of values.
%
% MASK, if asked for, will return a pattern of zeros and ones specifying which indices in the matrix 
% we are happy with.

wn=warning;
warning off;

N = length(BPx); M = length(BPy); S = N*M; XL = length(X); % Lengths of inputs

Xhat = sparse(XL,N); Yhat = sparse(XL,M); % Initialise matrices

for I = 1:N
    tempval = zeros(N,1);
    tempval(I) = 1;
    Xhat(:,I) = eval(cgmathsobject,'linear1',BPx,tempval,X); % X contribution towards regression matrix (phi contribution from X)
end

for J = 1:M
    tempval = zeros(M,1);
    tempval(J) = 1;
    Yhat(:,J) = eval(cgmathsobject,'linear1',BPy,tempval,Y); % Y contribution towards regression matrix (phi contribution from Y)
end

Xtilde = reshape(repmat(Xhat,[M,1]),XL,S); % Expand to a (XL*(N*M)) matrix so that we have the X contribution 
% Repeated for all y breakpoints.

Ytilde = repmat(Yhat,[1,N]); % Expand to a (XL*(N*M)) matrix so that we have the Y contribution 
% Repeated for all x breakpoints.

H = Xtilde.*Ytilde; % Regression matrix (Combine phi contributions)

V = H\Z; 

dg = diag(H'*H); % Any column with zero contributions is bad news - not enough data to give us meaningful reading,
% so we put this info in the mask.

Ind = zeros(size(V));

Ind(dg(:) ~= 0) = 1;

if ~any(Ind)
    err = 'Cannot invert this table.';
else
    err = [];
end

mask = reshape(Ind,[M,N]);

V = reshape(V,[M,N]);

warning(wn);

if nargout > 2
    varargout{1} = err;
end

return
        


