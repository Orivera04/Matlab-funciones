function FX= x2fx(m,X);
% MODEL/X2FX x2fx matrix for multivariate linear model
%
% FX= x2fx(m,X);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:50:24 $



if m.Constant
   % add column of ones if necessary.
   FX= [ones(size(X,1),1) X];
else
   FX= X;
end
   