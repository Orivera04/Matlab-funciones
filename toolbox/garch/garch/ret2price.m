function [TickSeries,TickTimes] = ret2price(RetSeries, StartPrice, RetIntervals, ...
                                            StartTime, Method)
%RET2PRICE Convert a return series to a price series.
%   Generate a price series for each of NUMASSETS assets given the asset 
%   starting prices and NUMOBS return observations for each asset.
%
%   [TickSeries, TickTimes] = ret2price(RetSeries)
%   [TickSeries, TickTimes] = ret2price(RetSeries    , StartPrice , ...
%                                       RetIntervals , StartTime  , Method)
%
%   Optional Arguments: StartPrice, RetIntervals, StartTime, Method
%
% Inputs:
%   RetSeries - Time series array of returns. RetSeries may be a vector or a
%     matrix. As a vector (row or column), RetSeries represents a univariate 
%     series of NUMOBS returns of a single asset; the first element contains the
%     oldest observation, and the last element the most recent. As a matrix, 
%     RetSeries represents a NUMOBS by NUMASSETS matrix of asset returns; rows 
%     correspond to time indices in which the first row contains the oldest 
%     observations and the last row the most recent. For a matrix RetSeries, 
%     observations across a given row are assumed to occur at the same time for
%     all columns, and each column is a return series of an individual asset.
%     RetSeries may be quoted with 'Continuous' or 'Periodic' compounding.
%     Type "help price2ret" for details.
%
% Optional Inputs:
%   StartPrice - A NUMASSETS element vector of initial prices for each asset, 
%     or a single scalar initial price applied to all assets. If StartPrice is
%     unspecified or empty, all asset prices start at 1.
%
%   RetIntervals - A NUMOBS element vector of time intervals between return 
%     observations, or a single scalar interval applied to all observations. 
%     If RetIntervals is unspecified or empty, all intervals are assumed to 
%     have length 1.
%
%   StartTime - Scalar starting time for the first observation, applied to the 
%     price series of all assets. The default is zero.
%
%   Method - Character string indicating the compounding method to compute asset
%     returns. If Method is empty, missing, or 'Continuous', then continuously 
%     compounded returns are computed; if Method is 'Periodic' then simple 
%     periodic returns are assumed. A case insensitive check is made of Method.
%
% Outputs:
%   TickSeries - Array of asset prices. When RetSeries is a NUMOBS element row
%     (column) vector, TickSeries will be a NUMOBS+1 row (column) vector. When 
%     RetSeries is a NUMOBS by NUMASSETS matrix, then RetSeries will be a
%     NUMOBS+1 by NUMASSETS matrix. As a vector, the first element contains the
%     starting price of the asset, and the element the most recent price. As a
%     matrix, the first row contains the starting price of the assets, and the
%     last row contains the most recent prices.
%
%   TickTimes - A NUMOBS+1 element vector of price observation times. The 
%     initial time is zero unless specified in StartTime.
%
% Example:
%   Create a stock price process continuously compounded at 10 percent, then 
%   compute 10 percent returns for reference, then reverse engineer prices:
%
%     S = 100*exp(0.10 * [0:19]')   % stock price series starting at $100
%     R = price2ret(S)              % 10 percent returns
%     P = ret2price(R , 100)        % prices such that P = S
%
% See also PRICE2RET.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.5.2.1 $   $Date: 2003/05/08 21:45:41 $ 

%
% If time series RetSeries is a vector (row or column), then assume 
% it's a univariate return series and ensure a column vector for working
% purposes. Retain a Boolean row vector flag for the output.
%

if prod(size(RetSeries)) == length(RetSeries)  % check for a vector.
   rowSeries  =  size(RetSeries,1) == 1;
   RetSeries  =  RetSeries(:);
else
   rowSeries  =  logical(0);
end


[NumObs , NumSeries]  =  size(RetSeries);

if (nargin < 2) | isempty(StartPrice)
   StartPrice  =  ones(1 , NumSeries);               % Default starting prices.
else
   if prod(size(StartPrice)) == 1
      StartPrice  =  StartPrice(ones(1,NumSeries));  % Scalar expansion.
   end
   if any(StartPrice(:) < 0)
      error('GARCH:ret2price:NegativePrices' , ' Negative intial prices in ''StartPrice'' are not allowed.');
   end
   if prod(size(StartPrice)) ~= length(StartPrice)   % Check for a vector.
      error('GARCH:ret2price:NonVectorPrices' , ' ''StartPrice'' must be a vector.');
   end
   if prod(size(StartPrice)) ~= NumSeries
      error('GARCH:ret2price:PriceVectorLengthMismatch' , ' Dimension mismatch between ''RetSeries'' and ''StartPrice''.')
   end
   StartPrice  =  StartPrice(:).';
end

rowTimes  =  [];

if (nargin < 3) | isempty(RetIntervals)
   RetIntervals  =  ones(NumObs , 1);                % Default interval length.
else
   if any(RetIntervals <= 0)
      error('GARCH:ret2price:NonPositiveIntervals' , ' ''RetIntervals'' must be positive time increments.')
   end
   if prod(size(RetIntervals)) == 1
      RetIntervals  =  RetIntervals(ones(NumObs,1)); % Scalar expansion.
   end
   if prod(size(RetIntervals)) ~= length(RetIntervals) % Check for a vector.
      error('GARCH:ret2price:NonVectorIntervals' , ' ''RetIntervals'' must be a vector.');
   else
      rowTimes  =  size(RetIntervals,1) == 1;
   end
   if prod(size(RetIntervals)) ~= NumObs             % Check the number of observations.
      error('GARCH:ret2price:TimeVectorLengthMismatch' , ' Dimension mismatch between ''RetSeries'' and ''RetIntervals''.')
   end
   RetIntervals  =  RetIntervals(:);
end

if (nargin < 4) | isempty(StartTime)
   StartTime  =  0;
elseif prod(size(StartTime)) ~= 1
   error('GARCH:ret2price:NonScalarStartTime' , ' ''StartTime'' must be a scalar.')
end

%
% Compute times by summing up intervals.
%

TickTimes  = cumsum([StartTime; RetIntervals]);

%
% Compute price series scaled by the time difference (i.e., interval) 
% between successive observations of the return series.
%

if (nargin == 5) & ~isempty(deblank(strjust(Method,'left'))) ...
                 & strmatch(deblank(strjust(lower(Method),'left')),'periodic','exact')
%
%  Periodic returns assumed, so price by multiplying 
%  the previous price by (1 + return*time) at each step.
%
   MulFactor  = 1 + (RetSeries .* RetIntervals(:,ones(NumSeries,1)));
   TickSeries = cumprod([StartPrice; MulFactor]);

else

%
%  Continuously-compounded returns assumed, so price by multiplying 
%  the previous price by exp(return*time) at each step.
%
   MulFactor  = exp(RetSeries .* RetIntervals(:,ones(NumSeries,1)));
   TickSeries = cumprod([StartPrice; MulFactor]);

end

%
% Re-format outputs for compatibility with the input(s). When RetSeries is
% input as a row vector, then pass TickSeries as a row vector. When RetIntervals 
% is input as a row vector, then pass TickTimes as a row vector; when RetIntervals
% is not specified, then pass TickTimes as a row vector if RetSeries is input as 
% a row vector.
%

if rowSeries
   TickSeries  =  TickSeries(:).'; 
end

if isempty(rowTimes)
   if rowSeries
      TickTimes  =  TickTimes(:).';
   end
else
   if rowTimes 
      TickTimes  =  TickTimes(:).';
   end
end



