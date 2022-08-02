function [YearConvexity, PerConvexity] = bndconvp(varargin)
%BNDCONVP Convexity of Bond Given Price.
%   This function calculates the convexity of NUMBONDS fixed income securities
%   given a clean price for each bond. This function will determine the 
%   convexity for a bond regardless of whether the bond's coupon structure
%   contains short or long first or last coupon periods (i.e. regardless of
%   whether the coupon structure is synched to maturity). This function will
%   also determine the convexity of a zero coupon bond.
%
%   [YearConvexity, PerConvexity] = bndconvp(Price, CouponRate,...
%          Settle, Maturity)
%
%   [YearConvexity, PerConvexity] = bndconvp(Price, CouponRate,...
%          Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,...
%          FirstCouponDate, LastCouponDate, StartDate, Face)
%
%
%   Inputs: All required inputs must be NUMBONDSx1 or 1xNUMBONDS conforming 
%     vectors or scalar arguments. All optional arguments must be either 
%     NUMBONDSx1 or 1xNUMBONDS conforming vectors, scalars, or empty matrices.
%     Optional inputs can also be passed as empty matrices or omitted at the
%     end of the argument list.  The value NaN in any optional input invokes
%     the default value for that entry.  Date arguments can be serial date
%     numbers or date strings.  For SIA bond argument descriptions, type
%     "help ftb".  For a detailed  description of a particular argument, for 
%     example Settle, type "help ftbSettle". 
%
%     Price (required) - Clean price
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
%     YearConvexity - Yearly convexity
%     PerConvexity - Periodic convexity
%         
%     Outputs are NUMBONDS by 1 vectors
%
%   See also BNDCONVY, BNDDURP, BNDDURY.

%   Author(s): C. Bassignani, M. Reyes-Kattar 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $   $Date: 2002/04/14 21:57:32 $ 

% Checking input arguments 
if (nargin < 4) 
     error('You must enter Price, CouponRate, Settle, and Maturity');
end 

% Make sure Price is in column vector form
Price = varargin{1}; 
Price = Price(:);

% Scale up the arguments and set defaults
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face] = instargbond(varargin{2:end});

% The scalar expansion done inside instargbond may not be 
% correct since it doesn't consider "Price". Make another
% scalar expansion to make sure sizes are appropriate.
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face, Price] = finargsz(1, CouponRate, Settle, Maturity, Period,...
   Basis, EndMonthRule, IssueDate, FirstCouponDate,LastCouponDate, StartDate, Face, Price);

% Find yield
Yield = bndyield(Price, CouponRate, Settle, Maturity, Period, Basis, EndMonthRule,...
   IssueDate, FirstCouponDate,LastCouponDate, StartDate, Face);

[YearConvexity, PerConvexity] = bndconvy(Yield, CouponRate, Settle, Maturity, Period,...
   Basis, EndMonthRule, IssueDate, FirstCouponDate,LastCouponDate, StartDate, Face);
