%FTB Financial Toolbox argument help listings
% Type "help ftpARGUMENT" for help on an argument or term named ARGUMENT.
% The following help is available:
%
% Coupon structure specification
%   ftbSettle              -  Settlement date
%
%   ftbMaturity            -  Maturity date
%   ftbIssueDate           -  Issue date
%   ftbStartDate           -  Forward starting date of instrument
%   ftbFirstCouponDate     -  First coupon date
%   ftbLastCouponDate      -  Last coupon date
%
%   ftbPeriod              -  Number of payments per year in market
%   ftbBasis               -  Market basis, e.g. 2 = actual/360
%   ftbEndMonthRule        -  Market end of month rule
%
% Bond amount specification
%   ftbCouponRate          -  Coupon rate
%   ftbFace                -  Face value
%
% Coupon payment lists
%   ftbCFlowAmounts        -  Amount of cash flow
%   ftbCFlowDates          -  Date of cash flow
%   ftbTFactors            -  Time factor from settlement
%   ftbCFlowFlags          -  Type and context of payment
%
% Individual instrument amount and yield parameters
%   ftbAccrfrac            -  Fraction of a coupon payment owed as accrued int.
%
% Individual instrument date parameters
%   ftbNumCouponsRemaining -  Number of coupons remaining to maturity
%   ftbNextCouponDate      -  Date of next coupon payment
%   ftbPreviousCoupondate  -  Date of previous or current payment
%   ftbNumDaysPeriod       -  Number of days in current coupon period
%   ftbNumDaysNext         -  Number of days to next payment
%   ftbNumDaysPrevious     -  Number of days since current payment
% 

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 21:56:59 $

fprintf('  type "helpwin ftb" for a description of online argument help\n');
