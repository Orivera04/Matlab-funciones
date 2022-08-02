function [Price, PriceNoAI] = bondbyzero(RateSpec, varargin)
%BONDBYZERO Price bonds in a portfolio by a set of zero curves.
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle,          Maturity,       ...
%                                Period,     Basis,           EndMonthRule,   ...
%                                IssueDate,  FirstCouponDate, LastCouponDate, ...
%                                StartDate,  Face)
%
%   Required Inputs:  
%     All inputs are either scalars or NINST by 1 vectors unless otherwise
%     specified. Dates can be serial date numbers or date strings. 
%     Optional arguments can be passed as empty matrices [].
%
%     RateSpec        - The annualized zero rate term structure.
%     CouponRate      - Decimal annual rate.
%     Settle          - Settlement date.
%     Maturity        - Maturity date.
%
%   Optional Inputs:
%     Period          - Coupons per year. Default is 2.
%     Basis           - Day-count basis. Default is 0 (actual/actual).
%     EndMonthRule    - End-of-month rule. Default is 1 (in effect.)
%     IssueDate       - Bond issue date.
%     FirstCouponDate - Irregular first coupon date.
%     LastCouponDate  - Irregular last coupon date.
%     StartDate       - Input ignored.
%     Face            - Face value. Default is 100.
%
%   Outputs:
%
%     Price - NINST by NUMCURVES matrix of clean bond prices.  Each
%     column arises from one of the zero curves.
%
%
%   See also CFBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.
%

%   Author(s): J. Akao, 11-29-1997, 10-15-98, M. Reyes-Kattar
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 21:41:05 $

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

% Make sure that RateSpec holds zero rates. Intepolate if it
% doesn't.
if(any(ValuationDate ~= intenvget(RateSpec, 'StartDates')))
   RateSpec = intenvset(RateSpec, 'StartDates', ValuationDate);
   ZeroRates   = intenvget(RateSpec, 'Rates');
end


% Process bond instrument arguments contained in varargin
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
      FirstCouponDate, LastCouponDate, StartDate, Face] = instargbond(varargin{:});
  
% Special rules: Single settlement value
if any(Settle ~= Settle(1))
   error('All bonds must settle the same day.');
else
  Settle = Settle(1);
end


if(ValuationDate > Settle(1))
   error('ValuationDate must be less than Settle.')
end


% Create the cash flow amounts, dates, and time factors and rearrange
% into a portfolio of cash flows.
% CFBondDate - NumBonds by NumDates
% AllDates   - NumDates by 1
% AllT       - NumDates by 1
[CFlowAmounts, CFlowDates, Tpds] = cfamounts(CouponRate, Settle, Maturity, ...
    Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face);

[CFBondDate, AllDates, AllT] = cfport(CFlowAmounts, CFlowDates, Tpds);

% Interpolate the zero curves to AllDates
% Old curve runs to ZeroDates from ValuationDate
% New curve runs to AllDates from Settle
% Last Settle invokes date interpretation
% AllZeros   -  NumDates by NumCurves
[AllZeros, ZeroT] = ratetimes(Compounding, ZeroRates, ZeroDates, ValuationDate, ...
                                           AllDates, Settle, ValuationDate);
% Compute the Discount factors for present value
% NumDates by NumCurves
AllDisc = rate2disc(Compounding, AllZeros, ZeroT, ZeroT(1));

% Present value of the cash flows for each bond (NumBonds by NumCurves)
Price = CFBondDate * AllDisc;

if nargout > 1
   % Calculate the present values of cash flows not including AI
   CFBondDateNoAI = CFBondDate;
   CFBondDateNoAI(:,1) = 0;
   
   PriceNoAI = CFBondDateNoAI * AllDisc;
end


return
