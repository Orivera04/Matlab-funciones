function [TS,alg]=mle_Algorithm(TS);
% TWOSTAGE/MLE_ALGORITHM determines the appropriate fit method for mle

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:51 $

if islinear(TS)
   alg= 'mle_GTS';
else
   alg= 'mle_nonlin';
end   
set(TS,'fitalg',alg);
