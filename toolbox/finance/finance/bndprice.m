function [Price, AccruedInt] = bndprice(varargin)
%BNDPRICE Price a fixed income security from yield to maturity.
%   Given NBONDS with SIA date parameters and semi-annual yields to
%   maturity, return the clean prices and the accrued interest due.
%         
%   [Price, AccruedInt] = bndprice(Yield, CouponRate, Settle, Maturity)
% 
%   [Price, AccruedInt] = bndprice(Yield, CouponRate, Settle, Maturity, ...
%       Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, ...
%       LastCouponDate, StartDate, Face)
%
%   Inputs: All required inputs must be NUMBONDSx1 or 1xNUMBONDS conforming 
%     vectors or scalar arguments. All optional arguments must be either 
%     NUMBONDSx1 or 1xNUMBONDS conforming vectors, scalars, or empty matrices.
%     Optional inputs can also be passed as empty matrices or omitted at 
%     the end of the argument list.  The value NaN in any optional input
%     invokes the default value for that entry.  Date arguments can be serial
%     date numbers or date strings.  For SIA bond argument descriptions,
%     type "help ftb".  For a detailed  description of a particular 
%     argument, for example Settle, type "help ftbSettle". 
%
%     Yield (required) - Yield to maturity on a semi-annual basis
%     CouponRate (required) - Coupon rate in decimal form
%     Settle (required) - Settlement date
%     Maturity (required) - Maturity date
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2
%     Basis - Day-count basis; default is 0 (actual/actual) 
%     EndMonthRule - End-of-month rule; default is 1 (in effect)
%     IssueDate - Bond issue date
%     FirstCouponDate - Irregular or normal first coupon date
%     LastCouponDate - Irregular or normal last coupon date
%     StartDate - Forward starting date of payments (Input ignored in 2.0)
%     Face - Face value of the bond; default is 100
%
%   Outputs: NBONDS by 1 vectors
%     Price - Clean price of the bond. 
%     AccruedInt - Accrued interest payable at settlement.
%
%   Notes:
%     The dirty price of the bond is the clean price plus the accrued
%     interest. It is equal to the present value of the bond cash flows.
%   
%     The Price and Yield are related by the formula:
%     Price + Accrued Interest = sum( Cash Flow*(1+Yield/2)^(-Time) )
%     where the sum is over the bond's cash flows and corresponding
%     times in units of semi-annual coupon periods.
%
%   See also BNDYIELD, CFAMOUNTS

%  Author(s): J. Akao 05/01/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%  $Revision: 1.11 $   $Date: 2002/04/14 21:57:26 $

% Checking input arguments 
if (nargin < 4) 
     error('You must enter Yield, CouponRate, Settle, and Maturity');
end 

% Make sure Yield is in column vector form
Yield = varargin{1}; 
Yield = Yield(:);

% Scale up the arguments and set defaults
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face] = instargbond(varargin{2:end});

% The scalar expansion done inside instargbond may not be 
% correct since it doesn't consider "Yield". Make another
% scalar expansion to make sure sizes are appropriate.
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face, Yield] = finargsz(1, CouponRate, Settle, Maturity, Period,...
   Basis, EndMonthRule, IssueDate, FirstCouponDate,LastCouponDate, StartDate, Face, Yield);


% Call cfamounts for bond parameters
[CFlowAmounts, CFlowDates, TFactors] = cfamounts(CouponRate, ...
    Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
    FirstCouponDate, LastCouponDate, StartDate, Face);

[NumBonds,MaxNumCFs] = size(CFlowAmounts);

% The first computed cash flow is the accrued interest
AccruedInt = - CFlowAmounts(:,1);

% use semi-anual compounding frequency for yields
Frequency = 2*ones(NumBonds,1);

% PerDisc     : Periodic discount rate 1/( 1 + Yield/Frequency )
PerDisc = 1./(1 + Yield./Frequency);

% Compute the discounts from settlement for every cash flow
DiscountRates = PerDisc(:,ones(1,MaxNumCFs)).^TFactors;

% Compute the present value of every cash flow (including accrued
% interest payment at settlement)
CFlowPVs = CFlowAmounts .* DiscountRates;
CFlowPVs( isnan(CFlowPVs) ) = 0;

% Sum the present value cash flows along the rows to get the price
Price = sum(CFlowPVs,2);

