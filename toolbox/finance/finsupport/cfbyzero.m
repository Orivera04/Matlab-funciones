function [Price] = cfbyzero(RateSpec, varargin)
%CFBYZERO Price cash flows by a set of zero curves.
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, Settle)
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, ...
%                              Settle, Basis)
%
%   Required Inputs: Type "help instcf" for a description of cash flow arguments.
%
%     RateSpec - The annualized zero rate term structure.
%
%     CFlowAmounts - NINSTxMOSTCFS matrix of cash flow amounts.  Each row is
%     a list of cash flow values for one instrument.  If an instrument has 
%     fewer than MOSTCFS cash flows, the end of the row is padded with NaN's.
%
%     CFlowDates - NINSTxMOSTCFS matrix of cash flow dates.  Each entry
%     contains the serial date of the corresponding cash flow 
%     in CFlowAmounts. 
%
%     Settle - Settlement date on which the cash flows are priced.
%
%   Optional Inputs:
%     Basis - Day-count basis.  Default is 0 (actual/actual).
%
%   Outputs:
%     Price - NINST by NUMCURVES matrix of cash flows prices.
%     Each column arises from one of the zero curves.
%
%
%   See also BONDBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.
% 

%   Author(s): J. Akao 25-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/14 21:38:47 $

% --------------------------------------------------------
% Checking the input arguments
% --------------------------------------------------------
if (nargin < 4) 
     error('You must enter RateSpec, CFlowAmounts, CFlowDates, and Settle');
end 

% Check first input argument to be term structure
if (nargin<1) | ~isafin(RateSpec,'RateSpec')
   error('The first argument must be a term structure created using INTENVSET');
end

%---------------------------------------------------------------------
% Parse input arguments
%---------------------------------------------------------------------
% Get term structure data
Compounding = intenvget(RateSpec, 'Compounding');
ZeroRates   = intenvget(RateSpec, 'Rates');
ZeroDates   = intenvget(RateSpec, 'EndDates');
ValuationDate = intenvget(RateSpec, 'ValuationDate');

if(isempty(Compounding) | isempty(ZeroRates) | isempty(ZeroDates) | isempty(ValuationDate))
   error('RateSpec must contain at least ''Compounding'', ''ZeroRates'', ''ZeroDates'', and ''ValuationDate''.')
end

% Make sure that RateSpec holds zero rates. Intepolate if it
% doesn't.
if(any(ValuationDate ~= intenvget(RateSpec, 'StartDates')))
   RateSpec = intenvset(RateSpec, 'StartDates', ValuationDate);
   ZeroRates   = intenvget(RateSpec, 'Rates');
end

% Parse standard CashFlow arguments
[CFAmounts, CFDates, Settle, Basis] = instargcf(varargin{:});

if any(Settle ~= Settle(1))
   error('All cash flow instruments must settle on the same day')
end

if(ValuationDate > Settle(1))
   error('ValuationDate must be less than Settle.')
end

% Find compounded TFactors for CFDates. TFactor = 0 represents
% the ValuationDate.
CFTimes = CFDates;
for iInst = 1:size(CFDates,1)
   CFTimes(iInst, ~isnan(CFTimes(iInst,:))) = ...
      date2time(ValuationDate, CFDates(iInst,~isnan(CFTimes(iInst,:))), RateSpec.Compounding, Basis(iInst))';
end

% Find the Time Factor for Settle
TSettle = date2time(ValuationDate, Settle(1), RateSpec.Compounding);

%---------------------------------------------------------------------
% Create a portfolio of cash flows
% Convert semi-annual TFactors to Times
%---------------------------------------------------------------------
[CFBondDate, AllDates, AllTimes] = cfport(CFAmounts, CFDates, CFTimes);


%---------------------------------------------------------------------
% Interpolate the zero curves to the correct times and find discounts
%---------------------------------------------------------------------
% Interpolate the zero curves to AllDates
% Old curve runs to ZeroDates from ValuationDate
% New curve runs to AllDates from Settle
% Last Settle invokes date interpretation
% AllZeros   -  NumDates by NumCurves

[AllZeros, ZeroT] = ratetimes(Compounding, ZeroRates, ZeroDates, ValuationDate, ...
                                     AllDates, Settle(1), ValuationDate);
AllDisc = rate2disc(Compounding, AllZeros, ZeroT, TSettle);

% Present value of the cash flows for each instrument (NumInst by NumCurves)
Price = CFBondDate * AllDisc;

return
