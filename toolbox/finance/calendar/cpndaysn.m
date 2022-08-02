function NumDaysNext = cpndaysn(varargin)
%CPNDAYSN Number of Days to Next Coupon Date.  
%   This function determines the number of days from settlement to the next quasi
%   coupon date for a set of NUMBOND fixed income securities. This
%   function will determine the number of days regardless of whether the
%   bond has an abnormal first or last coupon period. In the case of zero
%   coupon bonds this function returns the number of days from settlement to
%   the theoretical next quasi coupon date (i.e. the next coupon date 
%   that would prevail if the bond were a coupon bond).
%
%     NumDaysNext = cpndaysn(Settle, Maturity)
%
%     NumDaysNext = cpndaysn(Settle, Maturity, Period, Basis, EndMonthRule, ... 
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
%     NumDaysNext - NUMBONDS x 1 vector containing the number of days to
%     Next Coupon Date.
%         
%   See Also: CPNDAYSP, CPNDATEP, CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNPERSZ, 
%             CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.
 
%   Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.15 $   $Date: 2002/04/14 21:49:32 $ 

% Checking input arguments and set defaults
if (nargin < 2) 
     error('You must enter Settle and Maturity');
  end 
  
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
     FirstCouponDate, LastCouponDate, StartDate, Face] = instargbond(0 , varargin{:});

% Find the next quasi coupon date
NextCouponDate = cpndatenq(Settle, Maturity, Period, Basis,EndMonthRule, ...
   IssueDate, FirstCouponDate, LastCouponDate, StartDate);

% Now find the number of days between the settlement date and the first coupon date.
NumDaysNext = daysdif(Settle, NextCouponDate, Basis);
