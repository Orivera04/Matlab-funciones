function FX= x2fx(m,X)
%XREGHYBRIDRBF/X2FX Regression  matrix for hybrid RBFs
%
%  FX = CHANGEME(M,X) is the regression matrix for the hybrid RBF model M
%  at the evaluation points given by X.
%  FX = CHANGEME(M) uses the centers of the RBF as the evaluation points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:33 $

if nargin > 1,
    FX = [x2fx(m.linearmodpart,X) x2fx(m.rbfpart,X)];
else
    FX = [x2fx(m.linearmodpart,get(m.rbfpart,'Centers')), x2fx(m.rbfpart)];
end
