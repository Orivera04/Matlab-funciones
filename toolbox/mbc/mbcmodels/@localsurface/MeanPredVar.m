function [PEV,s] = MeanPredVar(m)
% xreglinear/MEANPREDVAR calculates the Mean Prediction Variance over [-1 1].
%
% It is called with the model that is being used
%    [PEV,s] = MeanPredVar(m)
%       PEV is mean value
%       s is square matrix such that PEV= trace(cov(m)*s)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:51 $

[PEV,s] = MeanPredVar(m.userdefined);