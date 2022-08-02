function [Price, PriceNoAI] = floatbyzero(RateSpec, varargin)
%FLOATBYZERO Price of a floating rate note by a set of zero curves.
%
%   Price = floatbyzero(RateSpec, Spread, Settle, Maturity)
%
%   Price = floatbyzero(RateSpec, Spread, Settle, Maturity, ...
%                                 Reset,  Basis,  Principal)
%
%   Required Inputs:  
%     All inputs are either scalars or NINST by 1 vectors unless otherwise
%     specified. Dates can be serial date numbers or date strings. 
%     Optional arguments can be passed as empty matrices [].
%
%     RateSpec - The annualized zero rate term structure.
%     Spread   - Number of basis points over the annualized zero curve. 
%     Settle   - Settlement date.
%     Maturity - Maturity date.
%
%   Optional Inputs:
%     Reset     - Frequency of payments per year. Default is 1.
%     Basis     - Day-count basis. Default is 0 (actual/actual).
%     Principal - Notional principal amount. Default is 100.
%
%   Outputs:
%     Price - NINST by NUMCURVES matrix of floating rate note prices. 
%             Each column arises from one of the zero curves.
%
%
%   See also BONDBYZERO, CFBYZERO, FIXEDBYZERO, SWAPBYZERO.
%

%   Author(s): M. Reyes-Kattar, 07/29/1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:41:11 $

% --------------------------------------------------------
% Checking the input arguments
% --------------------------------------------------------
if (nargin < 4) 
     error('You must enter RateSpec, Spread, Settle, and Maturity');
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

% Make sure we have serial dates.
if(ischar(ZeroDates))
   ZeroDates = datenum(ZeroDates);
end

% Check consistency among argument lengths
[RateRows, RateCols] = size(ZeroRates);
[DateRows, DateCols] = size(ZeroDates);

if RateRows ~= DateRows
   error('ZeroRates and ZeroDates must have the same number of rows.');
end

if DateCols ~= 1
   error('ZeroDates must be an NUMDATESx1 vector.');
end

% Make a copy of RateSpec to be used when calculating spot rates:
SpotRateSpec = RateSpec;

% Make sure that RateSpec holds zero rates. Intepolate if it
% doesn't.
if(any(ValuationDate ~= intenvget(RateSpec, 'StartDates')))
   RateSpec = intenvset(RateSpec, 'StartDates', ValuationDate);
   ZeroRates   = intenvget(RateSpec, 'Rates');
end

% Process the floating rate note instrument arguments contained in varargin
[Spread, Settle, Maturity, Reset, Basis, Principal] = instargfloat(varargin{:});
Spread = Spread(:);

% Special rules: Single settlement value
if any(Settle ~= Settle(1))
   error('All floating rate notes must settle the same day.');
else
  Settle = Settle(1);
end


if(ValuationDate > Settle(1))
   error('ValuationDate must be less than Settle.')
end


NumInst = size(Maturity,1);
NumCurves = RateCols;

% -------------------------------------------------------------
% Find the Cash Flow data for a fixed rate coupon with a 
% rate of 1. This will return the principal paid in each
% cash flow date. By multiplying these numbers by the spot
% rates applicable in the cash flow dates, we find the cash
% flows corresponding to the floating rate note.
[FixedCFA, CFlowDates, Tpds] = cfamounts(1, Settle, Maturity, ...
   Reset, Basis, [], [], [], [], [], Principal);

% -------------------------------------------------------------
% Determine the reset dates previous to settle in those cases
% where settle is not a reset date. Error out if rate is not
% available in RateSpec.
PrevCpnDate = cpndatep(Settle, Maturity, Reset, Basis);
BadInd = find(PrevCpnDate < ValuationDate);
if(~isempty(BadInd))
   errMsg = sprintf('Rate at %s cannot be obtained from RateSpec.\n', datestr(PrevCpnDate(BadInd(1))));
   errMsg = [errMsg 'This rate is required to calculate cash flows at Settle. Date is out of range'];
   error(errMsg);
end
AllCpnDates = [PrevCpnDate, CFlowDates];

% -------------------------------------------------------------
% Place all instruments in a common time line
[CFBondDate, AllDates, AllT] = cfport(FixedCFA, CFlowDates, Tpds);

% -------------------------------------------------------------
% Take off the principal from the last cash flow date of each
% instrument
[MatInd, IOrder] = findsub(AllDates, Maturity);
MatInd = MatInd(IOrder);
PIndex = sub2ind(size(CFBondDate),(1:length(MatInd))',MatInd);% Index to location of principals
CFBondDate(PIndex) = CFBondDate(PIndex) - Principal;

% Duplicate the cash flow rows once per zero curve:
CFBondDate = duplicaterows(CFBondDate, NumCurves);
% Find the new index to the principals:
PIndex = sub2ind(size(CFBondDate),(1:NumCurves*length(MatInd))',duplicaterows(MatInd, NumCurves));

% -------------------------------------------------------------
% Interpolate the zero curves to find the spots on the AllCpnDates
AllSpots = [];
for iInst = 1:size(AllCpnDates, 1)
   Dates = AllCpnDates(iInst, ~isnan(AllCpnDates(iInst, :)));
   EndDates = Dates(2:end)';   
   StartDates = Dates(1:end-1)';
   
   % Initialize a NPoints x NInst Spot rates array
   SpotCol = zeros(length(AllDates), NumCurves);
   
   % Find the location within the Spot rates array where the spots
   % will fall
   SpotIndex = findsub(AllDates, CFlowDates(iInst, ~isnan(CFlowDates(iInst, :))));
   
   % Set the compounding frequency equal to the instrument's reset frequency
   if(Reset(iInst) ~= intenvget(SpotRateSpec, 'Compounding'))
      SpotRateSpecTmp = intenvset(SpotRateSpec, 'Compounding', Reset(iInst));
   else
      SpotRateSpecTmp = SpotRateSpec;
   end
   
      
   % Use intenvset to find new spots
	SpotRateSpecTmp = intenvset(SpotRateSpecTmp, 'EndDates', EndDates, ...
   	'StartDates', StartDates, 'ValuationDate', ValuationDate);
  	Spots = intenvget(SpotRateSpecTmp, 'Rates');
  	SpotCol(SpotIndex, :) = Spots;
  
  	AllSpots = [AllSpots SpotCol];
end
AllSpots = AllSpots';

% Add the spreads
AllSpots = AllSpots + repmat(duplicaterows(Spread/10000, NumCurves), 1, size(AllSpots,2));


% -------------------------------------------------------------
% For now assume that the spot rate paid at settle is equal
% to the spot rate at the first reset date:
%AllSpots = [AllSpots(:,1) AllSpots];

% Find the cash flows as the product of principal * spot. 
CFBondDate = CFBondDate .* AllSpots;

% Add the principal to the new cash flows:
CFBondDate(PIndex) = CFBondDate(PIndex) + duplicaterows(Principal, NumCurves);

% Interpolate the zero curves to AllDates
% Old curve maps ZeroDates into ZeroRates.
% New curve maps AllDates into AllRates.
% AllZeros   -  NumDates by NumCurves
[AllZeros, ZeroT] = ratetimes(Compounding, ZeroRates, ZeroDates, ValuationDate, ...
                     AllDates, Settle, ValuationDate);

% Compute the Discount factors for present value
% NumDates by NumCurves
AllDisc = repmat(rate2disc(Compounding, AllZeros, ZeroT, ZeroT(1))', NumInst, 1);

% Calculate the floating rate note price
% Present value of the cash flows for each floating rate note (NINST by NumCurves)
Price = sum(CFBondDate .* AllDisc, 2);
Price = reshape(Price, NumCurves, NumInst)';

if nargout > 1
   % Calculate the present values of cash flows not including AI
   CFBondDateNoAI = CFBondDate;
   CFBondDateNoAI(:,1) = 0;
   
   PriceNoAI = sum(CFBondDateNoAI .* AllDisc, 2);
	PriceNoAI = reshape(PriceNoAI, NumCurves, NumInst)';	
end


return


%------------------------------------------
% DUPLICATEROWS:
%	duplicate N-times each row of input array Array.
%
%  Inputs:
%  	InArray: input array to be expanded
% 		    	N: number of times each row should
%            	be duplicated.
% ------------------------------------------
function OutArray = duplicaterows(InArray, N)

[NRows, NCols] = size(InArray);

Indexes = ((1:(NRows*NCols))' * ones(1, N))';
Indexes = reshape(Indexes, N*NRows, NCols);
OutArray = InArray(Indexes);

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
