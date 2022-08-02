function TFactors = cftimes(varargin)
%CFTIMES Time to Cash Flow in Fractional Coupon Periods.  
%   This function determines the time factors for NUMBONDS fixed income
%   securities. The term "time factors" refers to the time to cash flow  
%   in fractional semi-annual coupon periods.
%
%   TFactors = cftimes(Settle, Maturity)
%
%   TFactors = cftimes(Settle, Maturity, Period, Basis, EndMonthRule,...
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
%     TFactors - Time to cash flow. TFactors will have NUMBONDS rows, and 
%     the number of columns will be determined by the maximum number of cash 
%     flow payment dates required to hold the bond portfolio. NaN's are padded 
%     for bonds which have less than the maximum number of cash flow payment dates.
%
%   See also CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CPNPERSZ.
 
%   Author(s): C. Bassignani, M. Reyes-Kattar 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $   $Date: 2002/04/14 21:51:24 $ 

%Checking input arguments and set defaults
if (nargin < 2) 
     error('You must enter Settle and Maturity');
end 

%Call cfamounts to calculate the time factors
[Temp, Temp, TFactors] = cfamounts(0, varargin{:});

% Strip the settlement date from the TFactors matrix.
TFactors = TFactors(:,2:end);


