function FX = x2fx( m, X )
%X2FX Regression X matrix for RBF
%
%  FX = X2FX(M,X)
%  FX = X2FX(M) uses X = M.centers

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:34 $

if nargin < 2
    X = [];
end

if isempty(X) || isempty( m.centers )
    FX = zeros(size(X, 1), size(m.centers, 1));
else
    FX = xregrbfeval(getkernelstring(m), X, m.centers, m.width, []);
end
