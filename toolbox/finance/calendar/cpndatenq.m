function NextQuasiCouponDate = cpndatenq(varargin)
%CPNDATENQ Next Quasi-Coupon Date for a Fixed Income Security.
%   This function determines the next quasi-coupon date for a set of NUMBONDS
%   fixed income securities. Successive quasi-coupon dates determine the length 
%   of the standard coupon period for the fixed income security of interest, 
%   and do not necessarily coincide with actual coupon payment dates. This 
%   function finds the next quasi-coupon date for bonds with a coupon structure
%   whose first or last period is either normal, short, or long.
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity)
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity, Period, Basis, 
%                                     EndMonthRule, IssueDate, FirstCouponDate,
%                                     LastCouponDate)
%   Inputs: 
%     Settle - Settlement date.
%     Maturity - Maturity date.
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2 (semi-annual).
%     Basis - Day-count basis; default is 0 (actual/actual) .
%     EndMonthRule - End-of-month rule; default is 1 (rule in effect).
%     IssueDate - Bond issue date.
%     FirstCouponDate - Irregular or normal first coupon date.
%     LastCouponDate - Irregular or normal last coupon date.
%
%   Outputs: 
%     NextQuasiCouponDate - NUMBONDS-by-1 vector of next quasi-coupon dates 
%     after settlement. If settlement is a coupon date, this function never 
%     returns the settlement date. Instead, the quasi-coupon date strictly 
%     after settlement is returned.
%
%   Notes:
%     All required arguments must be NUMBONDSx1 or 1xNUMBONDS conforming vectors 
%     or scalar arguments. All optional arguments must be either NUMBONDSx1 or 
%     1xNUMBONDS conforming vectors, scalars, or empty matrices.  Fill 
%     unspecified entries in input vectors with the value NaN. Dates can be 
%     serial date numbers or date strings.
%
%     For a detailed description of each input and output argument, at the 
%     command line type: 'help ftb' + the argument name (e.g. for help on Settle,
%     type: "help ftbSettle").
%
%   See also CPNDATEN, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.6 $   $Date: 2002/04/14 21:51:27 $ 

%
% Perform bond input argument checking.
%

[CouponRate    , Settle      , Maturity , Period         , ...
 Basis         , EndMonthRule, IssueDate, FirstCouponDate, ...
 LastCouponDate, StartDate   , Face] = instargbond(0 , varargin{:});

%
% Set payment periodicity of zero-coupon bonds (i.e., Period = 0) to the 
% default semi-annual (i.e., Period = 2) for quasi-coupon calculations.
%

Period(Period == 0)  =  2;

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
% Find next quasi-coupon date.
%

[CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(:,3), referenceDate(:,2), ...
                                         referenceDate(:,1), offsetMonths      , Rule);

NextQuasiCouponDate  =  datenum(CpnYear , CpnMonth , CpnDay);

%
% Ensure the next quasi-coupon date occurs after settlement.
%

i  =  (NextQuasiCouponDate <= Settle);

if any(i)

   offsetMonths(i) = offsetMonths(i) + 12./Period(i);

   [CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(i,3), referenceDate(i,2), ...
                                            referenceDate(i,1), offsetMonths(i)   , Rule(i));

   NextQuasiCouponDate(i)  =  datenum(CpnYear , CpnMonth , CpnDay);

end
