function NumDaysPeriod = cpnpersz(varargin)
%CPNPERSZ Number of Days in Coupon Period.  
%   This function determines the number of days in the coupon period 
%   containing settlement date for NUMBONDS fixed income securities.
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity)
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity, Period, Basis, EndMonthRule,...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
%
%   Inputs: All required inputs must be NUMBONDSx1 or 1xNUMBONDS conforming 
%     vectors or scalar arguments. All optional arguments must be either 
%     NUMBONDSx1 or 1xNUMBONDS conforming vectors, scalars, or empty matrices.
%     Optional inputs can also be passed as empty matrices or omitted at 
%     the end of the argument list.  The value NaN in any optional input
%     invokes the default value for that entry.  Date arguments can be
%     serial date numbers or date strings.  For SIA bond argument descriptions,
%     type "help ftb".  For a detailed  description of a particular 
%     argument, for example Settle, type "help ftbSettle". 
%
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
%
%   Outputs: 
%     NumDaysPeriod - NUMBONDSx1 vector containing the number of days in 
%     coupon period containing settle.
%
%   See also CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC.
 
%   Author(s): C. Bassignani, 10-17-97, 07-31-98 
%   Copyright 1995-2004 The MathWorks, Inc.
%   $Revision: 1.13.2.3 $   $Date: 2004/04/06 01:06:22 $ 

% Checking input arguments and set defaults
if (nargin < 2) 
     error('You must enter Settle and Maturity');
end 

[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
      FirstCouponDate, LastCouponDate, StartDate, Face] = instargbond(0 , varargin{:});

% Find the previous quasi coupon date
PreviousCouponDate = cpndatepq(Settle, Maturity, Period, Basis, EndMonthRule,...
     IssueDate, FirstCouponDate, LastCouponDate, StartDate);

% Find the next quasi coupon date
NextCouponDate = cpndatenq(Settle, Maturity, Period, Basis,...
     EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,...
     StartDate);

% Find the number of days between the last coupon date and settlement date
% in an actual manner
NumDaysPeriod = daysact(PreviousCouponDate, NextCouponDate);

% adjust for those with 360 denominator
if (any(Basis == 1 | Basis == 2))
     
     Ind = find(Period == 1 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 360;
     
     Ind = find(Period == 2 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 180;
     
     Ind = find(Period == 3 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 120;
     
     Ind = find(Period == 4 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 90;
     
     Ind = find(Period == 6 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 60;
     
     Ind = find(Period == 12 & (Basis == 1 | Basis == 2));
     NumDaysPeriod(Ind) = 30;
     
end

% finally correct for those 
idx365 = find(Basis==3);

NumDaysPeriod(idx365) = days365(PreviousCouponDate(idx365), ...
    NextCouponDate(idx365));