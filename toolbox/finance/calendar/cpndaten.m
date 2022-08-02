function NextCouponDate = cpndaten(varargin)
%CPNDATEN Next Actual Coupon Date for a Fixed Income Security.
%   This function determines the next actual coupon payment date for a set 
%   of NUMBONDS fixed income securities. This function finds the next actual
%   coupon date for bonds with a coupon structure whose first or last period 
%   is either normal, short, or long. In the case of zero coupon bonds, the 
%   maturity date is returned.
%
%   NextCouponDate = cpndaten(Settle, Maturity)
%
%   NextCouponDate = cpndaten(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
%   Inputs: 
%     Settle - Settlement date.
%     Maturity - Maturity date.
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2 (semi-annual).
%     Basis - Day-count basis; default is 0 (actual/actual).
%     EndMonthRule - End-of-month rule; default is 1 (rule in effect).
%     IssueDate - Bond issue date.
%     FirstCouponDate - Irregular or normal first coupon date.
%     LastCouponDate - Irregular or normal last coupon date.
%
%   Outputs: 
%     NextCouponDate - NUMBONDS-by-1 vector of next actual coupon dates after
%     settlement. If settlement is a coupon date, this function never returns 
%     the settlement date. Instead, the actual coupon date strictly after 
%     settlement is returned, but not exceeding the maturity date. Thus, this
%     function will always return the lesser of the actual maturity date and
%     the next coupon payment date.
%
%   Notes:
%     All required arguments must be NUMBONDSx1 or 1xNUMBONDS conforming vectors 
%     or scalar arguments. All optional arguments must be either NUMBONDSx1 or 
%     1xNUMBONDS conforming vectors, scalars, or empty matrices. Fill unspecified
%     entries in input vectors with the value NaN. Dates can be serial date 
%     numbers or date strings.
%
%     For a detailed description of each input and output argument, at the 
%     command line type: 'help ftb' + the argument name (e.g. for help on Settle,
%     type: "help ftbSettle").
%
%   See also CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.25 $   $Date: 2002/04/14 21:51:15 $ 

%
% Perform bond input argument checking.
%

[CouponRate    , Settle      , Maturity , Period         , ...
 Basis         , EndMonthRule, IssueDate, FirstCouponDate, ...
 LastCouponDate, StartDate   , Face] = instargbond(0 , varargin{:});

%
% Set payment periodicity of zero-coupon bonds (i.e., Period = 0) to the 
% default semi-annual (i.e., Period = 2) for intermediate calculations.
%

zeroCouponBonds         =  (Period == 0);
Period(zeroCouponBonds) =  2;

%
% Determine reference date. The order of precedence is:
%  (1) First coupon date
%  (2) Last coupon date
%  (3) Maturity date
%

validLCDs  =  ~isnan(LastCouponDate);
validFCDs  =  ~isnan(FirstCouponDate);

referenceDate            =  Maturity;
referenceDate(validLCDs) =  LastCouponDate(validLCDs);
referenceDate(validFCDs) =  FirstCouponDate(validFCDs);

%
% Determine the indicator rule combining the day count basis
% and end-of-month convention (see DATEOFFSET for details).
%

Rule  =  Basis  +  4*(1 - EndMonthRule);

%
% Decompose the reference and settlement dates into (year, month, day)
% components and compute the number of months the settlement dates are
% offset from the reference dates.
%

referenceDate =  datevec(referenceDate);
SettleVec     =  datevec(Settle);

offsetMonths  =  12*(SettleVec(:,1) - referenceDate(:,1)) + (SettleVec(:,2) - referenceDate(:,2));
offsetMonths  =  ceil(offsetMonths.*Period/12) * 12./Period;

%
% Find next coupon date.
%

[CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(:,3), referenceDate(:,2), ...
                                         referenceDate(:,1), offsetMonths      , Rule);

NextCouponDate  =  datenum(CpnYear , CpnMonth , CpnDay);

%
% Ensure the next coupon date occurs after settlement.
%

i  =  (NextCouponDate <= Settle) & (NextCouponDate < Maturity);

if any(i)

   offsetMonths(i) = offsetMonths(i) + 12./Period(i);

   [CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(i,3), referenceDate(i,2), ...
                                            referenceDate(i,1), offsetMonths(i)   , Rule(i));

   NextCouponDate(i)  =  datenum(CpnYear , CpnMonth , CpnDay);

end

%
% Enforce some boundary effects.
%

i1  =  (Settle <  FirstCouponDate);
i2  =  (Settle >= LastCouponDate);

NextCouponDate(i1) =  FirstCouponDate(i1);
NextCouponDate(i2) =  Maturity(i2);

%
% Set next payment date of zero-coupon bonds to the bond maturity date.
%

NextCouponDate(zeroCouponBonds)  =  Maturity(zeroCouponBonds);

%
% Limit the next coupon payment date to the maturity date.
%

NextCouponDate(NextCouponDate > Maturity)  =  Maturity(NextCouponDate > Maturity);