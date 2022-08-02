function [CleanPrices] = prbyzero(Bonds, Settle, ... 
    ZeroRates, ZeroDates, Compounding)
%PRBYZERO Price bonds in a portfolio by a set of zero curves.
%
%   BondPrices = prbyzero(Bonds, Settle, ZeroRates, ZeroDates)
%
%   Inputs:
%     Bonds     - NUMBONDS by 6 portfolio of bond information.  
%                 Bonds = [Maturity, CouponRate, Face, CouponPeriod, Basis, EOM]
%     Settle    - Serial date number of the settlement date.
%     ZeroRates - NUMDATES by NUMCURVES matrix of observed zero curves
%     ZeroDates - NUMDATES by 1 column of dates for observed zeros
%
%   Outputs:
%     BondPrices - NUMBONDS by NUMCURVES matrix of clean bond prices.  Each
%                  column arises from one of the zero curves.
%
%   See also TR2BONDS, ZBTPRICE.

%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:57:44 $

[NumBonds, NumCols] = size(Bonds);
if (NumCols < 2)
  error(['The Bonds matrix must contain at least columns for the maturity' ...
         ' date and coupon rate'])
elseif (NumCols > 6)
  error('The Bonds matrix may only contain 6 columns')
end

% Set default columns: Face 100, Period 2, Basis 0, EOMRule 1.
Col = ones(NumBonds,1);
DefaultCols = [100*Col, 2*Col, 0*Col, 1*Col];
Bonds = [Bonds, DefaultCols(:, (NumCols-1):4)];
 
% Parse out bond parameters
Maturity = Bonds(:,1);
CpnRate  = Bonds(:,2);
Face     = Bonds(:,3);
Period   = Bonds(:,4);
Basis    = Bonds(:,5);
EOMRule  = Bonds(:,6);

% Set Compounding default
if nargin<5 | isempty(Compounding)
  Compounding = 2;
end

%----------------------------------------------------------------------
% Create the cash flow amounts and dates, and rearrange
% into a portfolio of cash flows.
% CFBondDate - NumBonds by NumDates
% AllDates   - NumDates by 1
%----------------------------------------------------------------------
[CFlowAmounts, CFlowDates] = cfamounts(CpnRate, Settle, Maturity, ...
    Period, Basis, EOMRule, [], [], [], [], Face);

[CFBondDate, AllDates] = cfport(CFlowAmounts, CFlowDates);

%----------------------------------------------------------------------
% Interpolate the zero curves to AllDates.  Account for Compounding and
% transform to discount factors.
% AllZeros  - NumDates by NumCurves
% AllT      - NumDates by 1 periodic times
% AllDisc   - NumDates by NumCurves
%----------------------------------------------------------------------

% Interpolate zero rates to AllDates
[AllZeros, AllT] = ratetimes(Compounding, ZeroRates, ZeroDates, Settle,...
                             AllDates, Settle, Settle);

% Compute the Discount factors for present value
AllDisc = rate2disc(Compounding, AllZeros, AllT);

%----------------------------------------------------------------------
% Present value of the cash flows for each bond (NumBonds by NumCurves)
%----------------------------------------------------------------------
CleanPrices = CFBondDate * AllDisc;

