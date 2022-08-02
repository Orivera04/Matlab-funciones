function [W,B,OK]= wbdecomp(X);
%WBDECOMP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:11 $

% creates a decomposition, WA = X, where W has orthogonal columns, A is upper triangular
% with ones on the diagonal, and n = size(X,2) 

[W,B,OK]= qrdecomp(X); 
diagonalB = diag(B);
W = W*diag(diagonalB);
B = diag(1./diagonalB)*B;

        

   
