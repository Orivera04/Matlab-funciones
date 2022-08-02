function [Price, PriceNoAI] = fixedbyzero(RateSpec, varargin)
%FIXEDBYZERO Price of a fixed rate note by a set of zero curves.
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity, ...
%                                 Reset, Basis,  Principal)
%
%   Required inputs:  
%     All inputs are either scalars or NINST by 1 vectors unless otherwise
%     specified. Dates can be serial date numbers or date strings. 
%     Optional arguments can be passed as empty matrices [].
%
%     RateSpec     - The annualized zero rate term structure.
%     CouponRate   - Decimal annual rate.
%     Settle       - Settlement date.
%     Maturity     - Maturity date.
%
%   Optional Inputs:
%     Reset        - Frequency of payments per year. Default is 1.
%     Basis        - Day-count basis. Default is 0 (actual/actual).
%     Principal    - Notional principal amount. Default is 100.
%
%   Outputs:
%     Price        - NINST by NUMCURVES matrix of fixed rate note prices. 
%                    Each column arises from one of the zero curves.
%
%
%   See also BONDBYZERO, CFBYZERO, FLOATBYZERO, SWAPBYZERO.
%

%   Author(s): M. Reyes-Kattar, 07-28-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:41:14 $

% --------------------------------------------------------
% Checking the input arguments
% --------------------------------------------------------
if (nargin < 4) 
     error('You must enter RateSpec, CouponRate, Settle, and Maturity');
end 

% Check first input argument to be term structure
if (nargin<1) | ~isafin(RateSpec,'RateSpec')
   error('The first argument must be a term structure created using INTENVSET');
end

% Get term structure data
Compounding = intenvget(RateSpec, 'Compounding');
ZeroRates   = intenvget(RateSpec, 'Rates');
ZeroDates   = intenvget(RateSpec, 'EndDates');
ValuationDate = intenvget(RateSpec, 'ValuationDate');

if(isempty(Compounding) | isempty(ZeroRates) | isempty(ZeroDates) | isempty(ValuationDate))
   error('RateSpec must contain at least ''Compounding'', ''ZeroRates'', ''ZeroDates'', and ''ValuationDate''.')
end
  
% Make sure we have serial dates
if(ischar(ZeroDates))
   ZeroDates = datenum(ZeroDates);
end

[RateRows, RateCols] = size(ZeroRates);
[DateRows, DateCols] = size(ZeroDates);

if RateRows ~= DateRows
   error('ZeroRates and ZeroDates must have the same number of rows.');
end

if DateCols ~= 1
   error('ZeroDates must be an NUMDATESx1 vector.');
end

% Process the fixed rate note instrument arguments contained in varargin
[CouponRate, Settle, Maturity, Reset, Basis, Principal] = instargfixed(varargin{:});

% Special rules: Single settlement value
if any(Settle ~= Settle(1))
   error('All fixed rate notes must settle the same day.');
else
  Settle = Settle(1);
end

if(ValuationDate > Settle(1))
   error('ValuationDate must be less than Settle.')
end

[Price, PriceNoAI] = bondbyzero(RateSpec, CouponRate, Settle, Maturity, ...
              Reset, Basis, [], [], [], [], [], Principal);



