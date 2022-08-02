function PreviousQuasiCouponDate = cpndatepq(varargin)
%CPNDATEPQ Previous Quasi-Coupon Date for a Fixed Income Security.
%   This function determines the previous quasi-coupon date for a set of NUMBONDS
%   fixed income securities. Prior quasi-coupon dates determine the length 
%   of the standard coupon period for the fixed income security of interest, 
%   and do not necessarily coincide with actual coupon payment dates. This 
%   function finds the previous quasi-coupon date for bonds with a coupon 
%   structure whose first or last period is either normal, short, or long.
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity)
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity, Period, Basis, 
%                                   EndMonthRule, IssueDate, FirstCouponDate,
%                                   LastCouponDate)
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
%     PreviousQuasiCouponDate - NUMBONDS-by-1 vector of previous quasi-coupon
%     dates before settlement. If settlement is a coupon date, this function 
%     returns the settlement date. 
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
%   See also CPNDATEN, CPNDATENQ, CPNDATEP, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     

%
% OLD CPNDATEPQ() HELP Header:
%
%CPNDATEPQ Previous Quasi Coupon Date for a Fixed Income Security
%
%This function determines the previous quasi coupon date for a set of NUMBOND 
%     fixed income securities. This function finds the previous quasi coupon 
%     date for a bond with a coupon structure in which the first or last 
%     period is either normal, short, or long (i.e. regardless of whether the
%     coupon structure is synched to maturity or not). In the case of zero 
%     coupon bonds this function returns the theoretical previous coupon date
%     that would prevail if the bond were a coupon bond).
%
%     The term "previous quasi coupon date" refers to the previous coupon date
%     for a bond calculated as if no issue date were specified. Although the
%     issue date is not actually a coupon date, when issue date is specified,
%     the previous actual coupon date for a bond is normally calculated 
%     as being either the previous date or the issue date, whichever is 
%     greater. Also, the actual previous coupon date and the previous quasi 
%     coupon date can also differ when the maturity date is not synched with
%     the coupon structure and the settlement date is the maturity date.
%     This function will always return the previous quasi coupon date whether
%     the issue date is greater. This function will only return a maturity
%     date as a previous coupon date if it is synch with coupon structure
%     of the bond.
%
%     PreviousQuasiCouponDate = cpndatepq(Settle, Maturity, Period, Basis,...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,
%          StartDate)
%
% Inputs: Settle (required) - Settlement date
%         Maturity (required) - Maturity date
%         Period - Coupons payments per year; default is 2
%         Basis - Day-count basis; default is 0 (actual/actual) 
%         EndMonthRule - End-of-month rule; default is 1 (in effect)
%         IssueDate - Bond issue date
%         FirstCouponDate - Irregular or normal first coupon date
%         LastCouponDate - Irregular or normal last coupon date
%         StartDate - Forward starting date of payments
%         
%         Unless specified as being required, all listed input arguments
%         are optional. All required arguments must be NUMBONDSx1 or 
%         1xNUMBONDS conforming vectors or scalar arguments. All optional 
%         arguments must be either NUMBONDSx1 or 1xNUMBONDS conforming 
%         vectors, scalars, or empty matrices. Fill unspecified entries in 
%         input vectors with the value NaN. Dates can be serial date numbers 
%         or date strings.
%
%         For a detailed description of each input and output argument, at
%         the command line type: 'help ftb' + the argument name (e.g. for
%         help on Settle, type: "help ftbSettle").
%
%Outputs: PreviousQuasiCouponDate - Previous quasi coupon date
%         
%         Outputs are NUMBONDS by 1 vectors
%
%         If the settlement date is a coupon date, this function always 
%         returns the settlement date. This function will only return
%         maturity date as a coupon date if it is in synch with the coupon
%         structure.
%
%See Also: CPNDATEP, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%          CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES

%
% IMPORTANT!  The whole code below is replicated in cpndatep().  The reason
%             why it is replicated is for performance purposes and the need
%             for the outputs from the function instargbond().
%

%Copyright 1995-2002 The MathWorks, Inc.
%$Revision: 1.9 $ $Date: 2002/04/14 21:51:30 $

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
offsetMonths  =  floor(offsetMonths.*Period/12) * 12./Period;

%
% Find next quasi-coupon date.
%

[CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(:,3), referenceDate(:,2), ...
                                         referenceDate(:,1), offsetMonths      , Rule);

PreviousQuasiCouponDate  =  datenum(CpnYear , CpnMonth , CpnDay);

%
% Ensure the next quasi-coupoun date occurs after settlement.
%

i  =  (PreviousQuasiCouponDate > Settle);

if any(i)

   offsetMonths(i) = offsetMonths(i) - 12./Period(i);

   [CpnDay, CpnMonth, CpnYear] = dateoffset(referenceDate(i,3), referenceDate(i,2), ...
                                            referenceDate(i,1), offsetMonths(i)   , Rule(i));

   PreviousQuasiCouponDate(i)  =  datenum(CpnYear , CpnMonth , CpnDay);

end

return
