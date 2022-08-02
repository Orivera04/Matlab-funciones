function [PEV,s] = MeanPredVar(m)
% xreglinear/MEANPREDVAR calculates the Mean Prediction Variance over [-1 1].
%
% It is called with the model that is being used
%    [PEV,s] = MeanPredVar(m)
%       PEV is mean value
%       s is square matrix such that PEV= trace(cov(m)*s)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:06 $

%

% Aly 3/6/99

% Run X2FX on the matrix X

N= length(get(m,'order'));
UpperLim= ones(1,N);
LowerLim= -UpperLim;

[int,s]= pevint(m,LowerLim,UpperLim);

PEV= int/prod(UpperLim-LowerLim);
if nargout > 1
   s= s/prod(UpperLim-LowerLim);
end
return
