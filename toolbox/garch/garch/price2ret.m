function [RetSeries,RetIntervals] = price2ret(TickSeries , TickTimes , Method)
%PRICE2RET Convert a price series to a return series.
%   Compute asset returns for NUMOBS price observations of NUMASSETS assets.
% 
%   [RetSeries , RetIntervals] = price2ret(TickSeries)
%   [RetSeries , RetIntervals] = price2ret(TickSeries , TickTimes , Method)
%
%   Optional Arguments: TickTimes, Method
%
% Inputs: 
%   TickSeries - Time series of price data. TickSeries may be a vector or a
%     matrix. As a vector (row or column), TickSeries represents a univariate 
%     series of NUMOBS prices of a single asset; the first element contains the
%     oldest observation, and the last element the most recent. As a matrix, 
%     TickSeries represents a NUMOBS by NUMASSETS matrix of asset prices; rows 
%     correspond to time indices in which the first row contains the oldest 
%     observations and the last row the most recent. For a matrix TickSeries, 
%     observations across a given row are assumed to occur at the same time for
%     all columns, and each column is a price series of an individual asset.
%
% Optional Inputs:
%   TickTimes - A NUMOBS element vector of monotonically increasing observation 
%     times. Times are numeric and taken either as serial date numbers (day 
%     units), or as decimal numbers in arbitrary units (e.g. yearly). If 
%     TickTimes is empty or missing, then sequential observation times from
%     1,2,...NUMOBS are assumed.
%
%   Method - Character string indicating the compounding method to compute asset
%     returns. If Method is empty, missing, or 'Continuous', then continuously 
%     compounded returns are computed; if Method is 'Periodic' then simple 
%     periodic returns are assumed. A case insensitive check is made of Method.
%
% Outputs:
%   RetSeries - Array of asset returns. When TickSeries is a NUMOBS element 
%     row (column) vector, RetSeries will be a NUMOBS-1 row (column) vector.
%     When TickSeries is a NUMOBS by NUMASSETS matrix, then RetSeries will
%     NUMOBS-1 by NUMASSETS matrix. The i'th return of an asset is quoted for
%     the period TickTimes(i) to TickTimes(i+1) and is normalized by the time
%     interval between successive price observations. 
%
%     Define RetIntervals(i) = TickTimes(i+1) - TickTimes(i), then by default 
%     the i'th return of an asset is continuously-compounded:
%
%     RetSeries(i) = log[TickSeries(i+1)/TickSeries(i)]/RetIntervals(i)
%
%     If Method = 'Periodic', then compute simple returns:
%
%     RetSeries(i) = [TickSeries(i+1)/TickSeries(i) - 1]/RetIntervals(i)
%
%   RetIntervals - NUMOBS-1 element vector of interval times between 
%     observations. If TickTimes is empty or unspecified, all intervals are 
%     assumed to be 1.
%
% Example:
%   Create a stock price process continuously compounded at 10 percent, then 
%   reverse engineer the 10 percent return series:
%
%     S = 100*exp(0.10 * [0:19]')   % stock price series
%     R = price2ret(S)              % 10 percent returns
%
% See also RET2PRICE.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.5.2.1 $   $Date: 2003/05/08 21:45:40 $ 

%
% If time series TickSeries is a vector (row or column), then assume 
% it's a univariate series and ensure a column vector. Retain a Boolean
% row vector flag for the outputs.
%

if prod(size(TickSeries)) == length(TickSeries)  % check for a vector.
   rowSeries   =  size(TickSeries,1) == 1;
   TickSeries  =  TickSeries(:);
else
   rowSeries   =  logical(0);
end

%
% Check for negative asset prices. 
%

if any(TickSeries(:) < 0)
   error('GARCH:price2ret:NegativePrices' , ' Negative asset prices in ''TickSeries'' are not allowed.');
end

%
% Check for asset prices of zero (worthless assets) prior to the 
% last (i.e., most recent) observation. Although the last price 
% for any asset may be zero, intermediate zero values violate a 
% fundamental arbitrage restriction and are NOT allowed.
%

if ~all(all(TickSeries(1:end-1,:)))
   error('GARCH:price2ret:ZeroPrices' , ' Only the most recent prices in ''TickSeries'' are allowed to be zero.');
end


[NumObs , NumSeries] = size(TickSeries);

if NumObs < 2
   error('GARCH:price2ret:InsufficientPrices' , ' At least 2 price observations of ''TickSeries'' are required to compute returns.');
end

%   
% Check 'TickTime' dimensions.
%

rowTimes  =  [];

if (nargin < 2) | isempty(TickTimes)
   TickTimes  =  [1:NumObs]';
else
   if prod(size(TickTimes)) ~= length(TickTimes)  % Check for a vector.
      error('GARCH:price2ret:NonVectorTimes' , ' ''TickTimes'' must be a vector.');
   else
      rowTimes   =  size(TickTimes,1) == 1;
   end
   if prod(size(TickTimes)) ~= NumObs             % Check for conformability.
      error('GARCH:price2ret:VectorLengthMismatch' , ' Dimension mismatch between ''TickSeries'' and ''TickTimes''.');
   end
   TickTimes  =  TickTimes(:);
end

%
% Compute observation time difference for returns intervals and ensure
% the monotonically increasing observation.
%

RetIntervals = diff(TickTimes); 

if any(RetIntervals <= 0)
   error('GARCH:price2ret:NonIncreasingTimes' , ' ''TickTimes'' must be monotonically increasing observation times.');
end

%
% Compute return series normalized by the time difference (i.e., interval) 
% between successive observations of the price series.
%

if (nargin == 3) & ~isempty(deblank(strjust(Method,'left'))) ...
                 & strmatch(deblank(strjust(lower(Method),'left')) , 'periodic' , 'exact')

%  Periodic returns.

   RetSeries  = (diff(TickSeries)./TickSeries(1:end-1,:))./RetIntervals(:,ones(NumSeries,1));

else

%  Continuously-compounded returns.

   RetSeries  =  diff(log(TickSeries))./RetIntervals(:,ones(NumSeries,1));

end

%
% Re-format outputs for compatibility with the input(s). When TickSeries is
% input as a row vector of prices of a single asset, then pass RetSeries as a 
% row vector. When TickTimes is input as a row vector, then pass RetIntervals
% as a row vector; when TickTimes is not specified, then pass RetIntervals
% as a row vector if TickSeries is input as a row vector.
%

if rowSeries
   RetSeries  =  RetSeries(:).'; 
end

if isempty(rowTimes)
   if rowSeries
      RetIntervals  =  RetIntervals(:).';
   end
else
   if rowTimes 
      RetIntervals  =  RetIntervals(:).';
   end
end
