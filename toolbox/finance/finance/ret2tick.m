function [TickSeries,TickTimes] = ret2tick(RetSeries, StartPrice, RetIntervals, ...
    StartTime, Method)
%RET2TICK Convert a return series to a price series.
%   Compute price values from the starting prices of NASSET assets and NUMOBS
%   return observations.
%
%   [TickSeries, TickTimes] = ret2tick(RetSeries)
%   [TickSeries, TickTimes] = ret2tick(RetSeries, StartPrice, RetIntervals, ...
%                                      StartTime, Method)
%
%   Optional Inputs: StartPrice, RetIntervals, StartTime, Method
%
% Inputs: 
%   RetSeries - NUMOBS by NASSETS time series array of asset returns 
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
% Optional Inputs:
%   StartPrice - NASSETS element row vector of initial prices for each asset, 
%     or a single scalar initial price applied to all assets. If StartPrice
%     is unspecified or empty, the initial price of all assets is 1.
%
%   RetIntervals - Scalar or NUMOBS element column vector of interval times 
%     between prices: RetIntervals(i) = TickTimes(i+1) - TickTimes(i). If 
%     RetIntervals is empty or unspecified, all intervals are assumed to be 1.
%
%   StartTime - Scalar starting time for the first observation, applied to
%     the price series of all assets. The default is zero.
%
%   Method - Character string indicating the method to convert asset returns 
%     to prices. If Method is 'Simple', then simple periodic returns are 
%     used. If Method is 'Continuous', then continuously compounded returns
%     are used. A case insensitive check is made of Method. The default is 
%     'Simple'.
%
% Outputs:
%   TickSeries - NUMOBS+1 by NASSETS time series array of asset prices. The 
%     first row contains the oldest observations and the last row the most
%     recent. Observations across a given row are assumed to occur at the 
%     same time for all columns, and each column is a price series of an 
%     individual asset. If Method is unspecified or 'Simple', then prices are
%     as follows:
%
%     TickSeries(i+1) = TickSeries(i)*[1 + RetSeries(i)]
%
%     If Method is 'Continuous', then prices are as follows:
%
%     TickSeries(i+1) = TickSeries(i)*exp[RetSeries(i)]
%
%   TickTimes - NUMOBS+1 element column vector of monotonically increasing
%     observation times associated with the prices in TickSeries. The initial
%     time is zero unless specified in StartTime, and sequential observation
%     times occur at unit increments unless specified in RetIntervals.
%
% See also TICK2RET.

%   Copyright 1995-2004 The MathWorks, Inc.  
%   $Revision: 1.6.2.1 $   $Date: 2003/11/29 20:34:40 $ 

%
% Check inputs.
%
if nargin < 5
	  Method = 'simple';
end

[NumObs, NumSeries] = size(RetSeries);

if (nargin < 2) || isempty(StartPrice)
   StartPrice = ones(1, NumSeries);                 % Default starting prices.
else
   if numel(StartPrice) == 1
      StartPrice = StartPrice(ones(1,NumSeries));   % Scalar expansion.
   end
   if size(StartPrice,2) ~= NumSeries
      error('Financial:ret2tick:InvalidDIMsRetSeriesVStartPrice', ...
            'Mismatched asset dimensions in RetSeries & StartPrice.')
   end
end

if (nargin < 3) || isempty(RetIntervals)
   RetIntervals = ones(NumObs, 1);                  % Default interval length.
else
   if numel(RetIntervals) == 1
      RetIntervals = RetIntervals(ones(NumObs,1));  % Scalar expansion.
   end
   if size(RetIntervals,1) ~= NumObs                % Check the number of observations.
      error('Financial:ret2tick:InvalidDIMsRetSeriesVRetIntervals', ...
            'Mismatched observation dimensions in RetSeries & RetIntervals.')
   end
end

if (nargin < 4) || isempty(StartTime)
   StartTime = 0;
elseif numel(StartTime) ~= 1
   error('Financial:ret2tick:StartTimeMustBeScalar', ...
         'StartTime must be a scalar.')
end

% 
% Compute times by summing up intervals.
%

TickTimes = cumsum([StartTime; RetIntervals]);

%
% Compute price series WITHOUT scaling by the time difference 
% between successive asset returns.
%

if isempty(Method) || any(strmatch(lower(Method), {'simple' 'periodic'}))
%
%  Simple returns: TickSeries(i+1) = TickSeries(i)*[1 + RetSeries(i)]
%
   MulFactor  = 1 + RetSeries;
   TickSeries = cumprod([StartPrice; MulFactor]);

elseif strmatch(lower(Method), 'continuous')
%
%  Continuously-compounded returns: TickSeries(i+1) = TickSeries(i)*exp[RetSeries(i)]
%
   MulFactor  = exp(RetSeries);
   TickSeries = cumprod([StartPrice; MulFactor]);
else
   error('Financial:ret2tick:invalidMethod', ...
         'Valid methods are ''Simple'' and ''Continuous''.');
end
