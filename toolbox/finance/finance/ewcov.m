function [VarMat, PDFlag] = ewcov(varargin)
%EWCOV Asset covariance from return series with exponential weighting.
%   [VarMat, PDFlag] = ewcov(TimeSeriesMatrix, DecayFactor, ...
%   LookBackHorizon) computes a covariance matrix from an asset return time
%   series over LookBackHorizon times.  
%
%   Inputs: 
%     TimeSeriesMatrix : NumObs x NumAssets matrix of incremental return
%     observations.  The first row of TimeSeriesMatrix contains the oldest 
%     observation for each variable, and subsequent rows contain more recent
%     observations, in historical order.
%
%     DecayFactor : scalar, 0 < DecayFactor <= 1. 
%     Observations are weighted by DecayFactor^k, where k is the number of time
%     steps back from the most recent observation. The default is DecayFactor = 1,
%     which represents the equally weighted-linear moving average model(BIS).
%     Smaller DecayFactors emphasize recent data more strongly.
%
%     LookBackHorizon : scalar integer, the number of time steps used in computing
%     the covariance.  The default is the entire time series of NumObs steps.
%     
%   Outputs: 
%     VarMat : NumAssets x NumAssets estimated covariance matrix. 
%     The standard deviations of the asset return processes are: 
%     STDVec = sqrt(diag(VarMat))
%     The correlation matrix is : CorrMat = VarMat./( STDVec*STDVec' )
%
%     PDFlag : 0 if VarMat is positive definite, 1 if VarMat is not
%     positive definite.  For some input data the estimated covariance
%     matrix is degenerate.  If this is the case, VarMat is still returned
%     but PDFlag is set to 1.
%
%   See also COV.
%

%   Author(s): J. Akao 03/17/1998
%   Copyright 1995-2002 The MathWorks, Inc.  
%   $Revision: 1.8 $   $Date: 2002/04/14 21:52:41 $ 

% This function may be superceeded by ewstats.m
[ERet, VarMat] = ewstats(varargin{:});

% Test if the estimated covariance is positive definite or degenerate
[Q,PDFlag] = chol(VarMat); % PSDFlag is 0 if positive def.
PDFlag = (PDFlag~=0);  % change output to either 0 or 1

% end of EWCOV function

