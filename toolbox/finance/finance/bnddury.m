function [ModDuration, YearDuration, PerDuration] = bnddury(varargin)
%BNDDURY Duration of Bond Given Yield.
%   This function calculates the Macaulay and Modified duration of NUMBONDS
%   fixed income securities given yield to maturity. This function will
%   determine the duration for a bond regardless of whether the bond's
%   coupon structure contains short or long first or last coupon periods
%   (i.e. regardless of whether the coupon structure is synched to 
%   maturity). This function will also determine the Macaulay and Modified
%   duration for a zero coupon bond.
%
%   [ModDuration, YearDuration, PerDuration] = bnddury(Yield, CouponRate,...
%          Settle, Maturity)
%
%   [ModDuration, YearDuration, PerDuration] = bnddury(Yield, CouponRate,...
%          Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,...
%          FirstCouponDate, LastCouponDate, StartDate, Face)
%
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
%   Outputs: 
%     ModifiedDuration - Modified duration
%     YearDuration - Macaulay duration in years
%     PerDuration - Periodic Macaulay duration
%         
%     Outputs are NUMBONDS by 1 vectors
%
%   See also BNDDURP, BNDCONVY, BNDCONVP.
 
%   Author(s): C. Bassignani, 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:57:41 $ 

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

% Call cfamounts to get cash flows and time factors for the all bonds
[CFlowAmounts, CFlowDates, TFactors] = cfamounts(CouponRate, Settle, ...
     Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, ...
     LastCouponDate, StartDate);

%Get the size of the porftolio
NumBonds = size(CFlowAmounts, 1);

% Set the frequency of any zero coupon bonds to "2"
Period(Period == 0) = 2;

% Set the frequency of all non semi-annual pay coupon bonds to "2"
Period(Period == 1) = 2;
Period(Period == 12) = 2;
Period(Period == 6) = 2;
Period(Period == 4) = 2;
Period(Period == 3) = 2;

%-----------------------------------------------------------------------------
% Assign all intermediate variables
TF = TFactors(:, 2 : end);
CF = CFlowAmounts(:, 2 : end);
YLD = Yield(:, ones(1, size(CF, 2)));
PeriodMat = Period(:, ones(1, size(CF, 2)));

%-----------------------------------------------------------------------------
% Calculate periodic Macaulay duration

A = nan .* ones(NumBonds, 1);
B = A;

for(i = 1 : NumBonds)
     
     a = TF(i, :) .* CF(i, :) ./ ((1 + YLD(i, :) ./ PeriodMat(i, :)) ...
          .^ TF(i, :));
     
     SumInd = find(~isnan(a));
     
     A(i, 1) = sum( a(SumInd) , 2);
     
     b = CF(i, :) ./ ((1 + YLD(i, :) ./ PeriodMat(i, :)) .^ TF(i, :));
     
     SumInd = find(~isnan(b));
     
     B(i, 1) = sum( b(SumInd) , 2);
end

PerDuration = A ./ B;

% Calculate yearly duration
YearDuration = PerDuration ./ Period;

% Now calculate modified duration
ModDuration = YearDuration ./ (1 + Yield ./ Period);


