function [RetSeries,RetIntervals] = tick2ret(TickSeries,TickTimes,Method)
%TICK2RET Convert a price series to a return series.
%   Compute asset returns for NUMOBS price observations of NASSETS assets.
%
%   [RetSeries, RetIntervals] = tick2ret(TickSeries)
%   [RetSeries, RetIntervals] = tick2ret(TickSeries, TickTimes, Method)
%
%   Optional Inputs: TickTimes, Method
%
% Inputs: 
%   TickSeries - NUMOBS by NASSETS time series array of asset prices. The 
%     first row contains the oldest observations and the last row the most
%     recent. Observations across a given row are assumed to occur at the 
%     same time for all columns, and each column is a price series of an 
%     individual asset.
%
% Optional Inputs:
%   TickTimes - NUMOBS element column vector of monotonically increasing
%     observation times associated with the prices in TickSeries. Times are
%     numeric and taken either as serial date numbers (day units), or as 
%     decimal numbers in arbitrary units (e.g. yearly). If TickTimes is empty
%     or missing, then sequential observation times from 1,2,...NUMOBS are 
%     assumed.
%
%   Method - Character string indicating the method to compute asset returns. 
%     If Method is 'Simple', then simple periodic returns are computed. If 
%     Method is 'Continuous', then continuously compounded returns are 
%     computed. A case insensitive check is made of Method. The default is 
%     'Simple'.
%
% Outputs:
%   RetSeries - NUMOBS-1 by NASSETS time series array of asset returns 
%     associated with the prices in TickSeries. The i'th return is quoted for 
%     the period TickTimes(i) to TickTimes(i+1) and is not normalized by the
%     time increment between successive price observations. If Method is 
%     unspecified or 'Simple', then returns are as follows:
%
%     RetSeries(i) = TickSeries(i+1)/TickSeries(i) - 1
%
%     If Method is 'Continuous', then continuous returns are as follows:
%
%     RetSeries(i) = log[TickSeries(i+1)/TickSeries(i)]
%
%   RetIntervals - NUMOBS-1 element column vector of interval times between
%     price observations: RetIntervals(i) = TickTimes(i+1) - TickTimes(i). If 
%     TickTimes is empty or unspecified, all intervals are assumed to be 1.
%
% See also RET2TICK.

%   Copyright 1995-2004 The MathWorks, Inc.  
%   $Revision: 1.7.2.1 $   $Date: 2003/11/29 20:34:41 $ 

% 
% Check inputs.
%

if nargin < 3
	  Method = 'simple';
end

[NumObs, NumSeries] = size(TickSeries);

if NumObs < 2
%  Catch a single transposed series.
   error('Finance:tick2ret:requireAtLeast2Observations', ...
				     'At least 2 price observations of TickSeries are required.');
end
   
% Check 'TickTime' dimensions.
if (nargin < 2) || isempty(TickTimes)
   TickTimes = [1:NumObs]';
elseif (size(TickTimes,1) ~= NumObs)
	  error('Finance:tick2ret:invalidDIMsTickseriesVTicktimes', ...
			      'Mismatched number of observations in TickSeries & TickTimes.');
end

%
% Compute observation time difference for returns intervals.
%

RetIntervals = diff(TickTimes); 

%
% Compute return series WITHOUT normalizing by the time difference 
% between successive observations of the price series.
%

if isempty(Method) || any(strmatch(lower(Method), {'simple' 'periodic'}))
%
%  Simple returns: RetSeries(i) = [TickSeries(i+1)/TickSeries(i) - 1]
%
   RetSeries = diff(TickSeries)./TickSeries(1:end-1,:);

elseif strmatch(lower(Method), 'continuous')
%
%  Continuously-compounded returns: RetSeries(i) = log[TickSeries(i+1)/TickSeries(i)]
%
   RetSeries = diff(log(TickSeries));

else
   error('Finance:tick2ret:invalidMethod', ...
				     'Valid methods are ''Simple'' and ''Continuous''.');
end
