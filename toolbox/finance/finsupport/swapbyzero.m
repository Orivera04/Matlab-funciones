function [Price, SwapRate] = swapbyzero(RateSpec, varargin)
%SWAPBYZERO Price a vanilla swap by a set of zero curve(s).
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate, Settle, Maturity)
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate,  Settle, Maturity,...
%                                           LegReset, Basis,  Principal, LegType)
%
%   Required Inputs: 
%     Dates can be serial date numbers or date strings. 
%     Optional arguments can be passed as empty matrices [].
%
%     RateSpec - The annualized zero rate term structure.
%
%     LegRate - NINSTx2 matrix, with each row defined as follows: 
%     [CouponRate Spread] or [Spread CouponRate]
%     where CouponRate is the decimal annual rate and Spread is the number of
%     basis points over the annualized zero curve. The first column represents
%     the receiving leg, while the second column represents the paying leg.      
%
%     Settle - NINSTx1 vector of dates representing the settle date for each 
%     swap.
%
%     Maturity - NINSTx1 vector of dates representing the maturity date for 
%     each swap.
%
%   Optional Inputs:
%     LegReset - NINSTx2 matrix representing the reset frequency per year for 
%     each swap. Default is [1 1].
%
%     Basis - NINSTx1 vector representing the basis used when annualizing 
%     the input forward rate tree for each instrument. The default
%     is 0 (actual/actual).
%
%     Principal - NINSTx1 vector of the notional principal amounts. 
%     Default is 100.
%  
%     LegType - NINSTx2 matrix, with each row representing an instrument, and 
%     each column indicating if the corresponding leg is fixed or floating.  
%     A value of 0 represents a floating leg, and a value of 1 represents 
%     a fixed leg. Use this matrix to define how to interpret the values
%     entered in the Matrix LegRate. Default is [1,0] for each instrument.
%
%   Outputs:
%     Price - NINST by NUMCURVES matrix of swap prices. 
%     Each column arises from one of the zero curves.
%
%     SwapRate - NINST by NUMCURVES matrix of rates applicable to the fixed leg  
%     such that the swaps' values are zero at Settle. This rate is calculated
%     and used in calculating the swaps prices when the rate specified for 
%     the fixed leg in LegRate is NaN. SwapRate is padded with NaNs for those
%     instruments in which the coupon rate is not set to NaN. 
%
%
%   See also BONDBYZERO, CFBYZERO, FIXEDBYZERO, FLOATBYZERO.

%   Author(s): M. Reyes-Kattar, 02/07/2000
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:41:32 $

% -------------------------------------------------------------
% Checking the input arguments
% -------------------------------------------------------------
if (nargin < 4) 
     error('You must enter RateSpec, LegRate, Settle, and Maturity');
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

NumCurves = RateCols;

% Process swap instrument arguments contained in varargin
[LegRate, Settle, Maturity, LegReset, Basis, Principal, LegType] = instargswap(varargin{:});

% Special rules: Single settlement value
if any(Settle ~= Settle(1))
   error('All swaps must settle the same day.');
end

if(ValuationDate > Settle(1))
   error('ValuationDate must be less than Settle.')
end

% -------------------------------------------------------------
% Separate floating notes from fixed notes
% -------------------------------------------------------------
[NumInst, NumCols] = size(LegType);

floatInd = find(LegType == 0);
fixedInd = find(LegType == 1);

Spreads = LegRate(floatInd);
FixedRates  = LegRate(fixedInd);

FloatResets = LegReset(floatInd);
FixedResets = LegReset(fixedInd);

Mat  = repmat(Maturity, 1, NumCols);
Bas  = repmat(Basis, 1, NumCols);
Prin = repmat(Principal, 1, NumCols);

FloatMaturity = Mat(floatInd);
FixedMaturity = Mat(fixedInd);

FloatBasis = Bas(floatInd);
FixedBasis = Bas(fixedInd);

FloatPrincipal = Prin(floatInd);
FixedPrincipal = Prin(fixedInd);


% -------------------------------------------------------------
% If any of the coupon rates is a NaN, we need to calculate the
% coupon rates. Find their location for later processing
SRFixedInd = [];
if any(isnan(FixedRates))
   [SRFixedInd, SRFloatInd] = findSwapRateInds(LegRate, LegType, floatInd, fixedInd);
end

% --------------------------------------------------------------
% Find prices for each one of the instruments
% --------------------------------------------------------------
[dummy, FloatPrice] = floatbyzero(RateSpec, Spreads, Settle,...
   						FloatMaturity, FloatResets, FloatBasis, FloatPrincipal);
                  
                  
FixedPrice = nan*ones(length(fixedInd), NumCurves);
% --------------------------------------------------------------
% If any of the fixed legs were set to NaN, we must calculate the
% corresponding SwapRate
if any(isnan(FixedRates))
   SwapRates = findswaprates(RateSpec, FloatPrice(SRFloatInd, :), ...
      Settle(SRFixedInd), FixedPrincipal(SRFixedInd), FixedMaturity(SRFixedInd),...
      FixedResets(SRFixedInd), FixedBasis(SRFixedInd));
   
   % Arrange all the fixed rate notes in a single column, and find the prices
   SRNumFixed = length(SRFixedInd);
   SRSwapRates = SwapRates(:);
   SRFixedMaturity = repmat(FixedMaturity(SRFixedInd), NumCurves,1 );
   SRFixedResets   = repmat(FixedResets(SRFixedInd), NumCurves,1 );
   SRFixedBasis    = repmat(FixedBasis(SRFixedInd), NumCurves, 1);
   SRFixedPrincipal= repmat(FixedPrincipal(SRFixedInd), NumCurves, 1);
   
	[dummy, SRFixedPrice] = fixedbyzero(RateSpec, SRSwapRates, Settle(1),...
      SRFixedMaturity, SRFixedResets, SRFixedBasis, SRFixedPrincipal);
   
   % Extract the prices that we are interested in and place them in their
   % appropriate slots in the FixedPrice matrix
   SRRows = (1:(SRNumFixed*NumCurves))';
   SRCols = repmat(1:NumCurves, SRNumFixed, 1);
   SRCols = SRCols(:);
   FixedPrice(SRFixedInd,:) = reshape(SRFixedPrice(sub2ind(size(SRFixedPrice), SRRows, SRCols)),...
      SRNumFixed, NumCurves);
end

% Calculate the non-swap rate prices
NSRFixedMask = ~isnan(FixedRates);
if(any(NSRFixedMask))
   [dummy, FixedPrice(NSRFixedMask,:)] = fixedbyzero(RateSpec, FixedRates(NSRFixedMask), ...
      Settle(1), FixedMaturity(NSRFixedMask), FixedResets(NSRFixedMask), ...
      FixedBasis(NSRFixedMask), FixedPrincipal(NSRFixedMask));
end

                                             
% --------------------------------------------------------
% Find the Price of each swap
% --------------------------------------------------------
[floatRows, floatCols] = ind2sub([NumInst, NumCols], floatInd);
[fixedRows, fixedCols] = ind2sub([NumInst, NumCols], fixedInd);

IFloat = 1:length(floatInd);
IFixed = 1:length(fixedInd);

LVals = NaN*ones(NumInst,NumCurves);
RVals = LVals;

LVals(floatRows(floatCols == 1),:) = FloatPrice(IFloat(floatCols==1),:);
LVals(fixedRows(fixedCols == 1),:) = FixedPrice(IFixed(fixedCols==1),:);
   
RVals(floatRows(floatCols == 2),:) = FloatPrice(IFloat(floatCols==2),:);
RVals(fixedRows(fixedCols == 2),:) = FixedPrice(IFixed(fixedCols==2),:);

Price =  LVals - RVals;

% --------------------------------------------------------
% If requested, return the SwapRate where applicable
% --------------------------------------------------------
if nargout == 2
   SwapRate = NaN*ones(NumInst, NumCurves); 
   if ~isempty(SRFixedInd)
      SwapRate(fixedRows(SRFixedInd), :) = SwapRates;
   end   
end

return


% ---------------------------------------------------------
% Aux function to find the location of the instruments needed to
% calculate the SwapRates
function [SRFixedInd, SRFloatInd] = findSwapRateInds(LegRate, LegType, floatInd, fixedInd)   
NumInst = size(LegRate,1);
% ---------------------------------------------------------
% If any of the coupon rates was entered as NaN, we must
% substitute it by the corresponding swap rate.
% ---------------------------------------------------------
[SwapRateRowInd, SwapRateColInd] = find(isnan(LegRate));
SwapRateInd = sub2ind(size(LegType), SwapRateRowInd, SwapRateColInd);
   
% ---------------------------------------------------------
% Only Fixed Rate notes can have a NaN for their rates
% ---------------------------------------------------------
if(~all(LegType(SwapRateInd) == ones(size(SwapRateInd))))
   error('Only a fixed leg is allowed to use NaN as its rate');
end
   
% ---------------------------------------------------------
% Make sure that they're either float/fixed of fixed/float swaps
% ---------------------------------------------------------
if(any(diff(LegType(SwapRateRowInd,:), 1, 2))==0)
   error('Swap rates can only be calculated for vanilla swaps.')
end

% -------------------------------------------------------------
% Indentify Swap Rate rows. Sister Float and Fixed Rate Notes in 
% swaps will share the same rows.
% -------------------------------------------------------------
SwapRateRowMask = zeros(size(LegRate));
SwapRateRowMask(SwapRateRowInd,:) = 1;

SwapFloatInd = find(SwapRateRowMask & (LegType == 0));
SwapFixedInd = NaN*ones(size(SwapFloatInd));
SwapFixedInd(SwapFloatInd>NumInst)  = SwapFloatInd(SwapFloatInd>NumInst)-NumInst;
SwapFixedInd(SwapFloatInd<=NumInst)   = SwapFloatInd(SwapFloatInd<=NumInst)+NumInst;

[SRFloatInd, IOrder] = findsub(floatInd, SwapFloatInd);
SRFloatInd = SRFloatInd(IOrder);
[SRFixedInd, IOrder] = findsub(fixedInd, SwapFixedInd);
SRFixedInd = SRFixedInd(IOrder);

return

% -----------------------------------------
% FINDSUB:
% Find the indices within All where the
% elements of Sub are found. IOrder keeps
% the order in which they appear:
% Ind(IOrder) = Sub when all elements of Sub
% can be found in All
function [Ind, IOrder] = findsub(All, Sub)

lengthAll  = length(All);
lengthSub = length(Sub);
IMask = (repmat(All(:)', lengthSub,1)== repmat(Sub(:), 1, lengthAll));
[I, Ind] = find(IMask);
[dummy, IOrder] = sort(I);
return
