function [ERet, ECov, NEff] = ewstats(RetSeries, DecayFactor, WindowLength)
%EWSTATS Expected return and covariance from return time series.  
%   Optional exponential weighting emphasizes more recent data.
% 
%   [ExpReturn, ExpCovariance, NumEffObs] = ewstats(RetSeries, ...
%                                           DecayFactor, WindowLength)
%  
%   Inputs:
%     RetSeries : NUMOBS by NASSETS matrix of equally spaced incremental 
%     return observations.  The first row is the oldest observation, and the
%     last row is the most recent.
%
%     DecayFactor : Controls how much less each observation is weighted than its
%     successor.  The k'th observation back in time has weight DecayFactor^k.
%     DecayFactor must lie in the range: 0 < DecayFactor <= 1. 
%     The default is DecayFactor = 1, which is the equally weighted linear
%     moving average Model (BIS).  
%
%     WindowLength: The number of recent observations used in
%     the computation.  The default is all NUMOBS observations.
%
%   Outputs:
%     ExpReturn : 1 by NASSETS estimated expected returns.
% 
%     ExpCovariance : NASSETS by NASSETS estimated covariance matrix.  
%
%     NumEffObs: The number of effective observations is given by the formula:
%     NumEffObs = (1-DecayFactor^WindowLength)/(1-DecayFactor).  Smaller
%     DecayFactors or WindowLengths emphasize recent data more strongly, but
%     use less of the available data set.
%
%   The standard deviations of the asset return processes are given by:
%   STDVec = sqrt(diag(ECov)).  The correlation matrix is :
%   CorrMat = VarMat./( STDVec*STDVec' )
%
%   See also MEAN, COV, COV2CORR.

%   Author(s): J. Akao 3/16/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $   $Date: 2002/04/14 21:52:38 $ 

[NumObs, NumSeries] = size(RetSeries);
   
% size the series and the window
if nargin < 3
   WindowLength = NumObs;
end

if nargin < 2
   DecayFactor = 1;   
end

if DecayFactor <= 0 | DecayFactor > 1
	error('Must have 0< decay factor <= 1.');
end
   
if (WindowLength > NumObs)
  error(sprintf('Window Length %d must be <= number of observations %d',... 
      WindowLength, NumObs));
end

% ------------------------------------------------------------------------
% size the data to the window
RetSeries = RetSeries(NumObs-WindowLength+1:NumObs, :);

% Calculate decay coefficients
DecayPowers = (WindowLength-1 : -1 : 0)';
VarWts = sqrt(DecayFactor).^DecayPowers; 
RetWts =     (DecayFactor).^DecayPowers;

NEff = sum(RetWts); % number of equivalent values in computation

% Compute the exponentially weighted mean return
WtSeries = RetWts(:,ones(1,NumSeries)).* RetSeries;
ERet = sum(WtSeries,1)/NEff;

% Subtract the weighted mean from the original Series
CenteredSeries = RetSeries - ERet(ones(WindowLength,1),:);

% Compute the weighted variance
WtSeries = VarWts(:,ones(1,NumSeries)).* CenteredSeries;
ECov = WtSeries'*WtSeries/NEff;

