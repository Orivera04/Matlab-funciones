function [m,OK] = calcWeights(m,x,y)
%CALCWEIGHTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:23 $

% calculate the weights for an rbf, when all fit parameters are known
% assumes m.centers, m.lambda, and m.width are all filled
% and all terms are used
    

% the computation of the beta is always the same (beta = R\(Q'*y)), where
% Q and R must have been initialised appropriately in InitModel
[m,OK]= leastsq(m,x,y);
