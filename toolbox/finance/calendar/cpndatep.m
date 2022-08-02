function PreviousCouponDate = cpndatep(varargin)
%CPNDATEP Previous Actual Coupon Date for a Fixed Income Security.
%   This function determines the previous actual coupon payment date for a set 
%   of NUMBONDS fixed income securities. This function finds the previous actual
%   coupon date for bonds with a coupon structure whose first or last period 
%   is either normal, short, or long. In the case of zero coupon bonds, the 
%   issue date is returned, if supplied; if the issue date is not supplied, 
%   the previous quasi coupon date is returned.
%
%   PreviousCouponDate = cpndatep(Settle, Maturity)
%
%   PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
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
%     PreviousCouponDate - NUMBONDS-by-1 vector of previous actual coupon dates on 
%     or before settlement. If settlement is a coupon date, this function returns 
%     the settlement date. The actual coupon date strictly on or before settlement 
%     is returned, but not exceeding the issue date, if available. Thus, this
%     function will always return the lesser of the actual issue date and
%     the previous coupon payment date with respect to settlement date.
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
%   See also CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.

%
% OLD CPNDATEP() HELP Header:
%
%CPNDATEP Previous Coupon Date for a Fixed Income Security
%
%This function determines the previous coupon date for a set of NUMBOND 
%     fixed income securities. This function finds the previous coupon date 
%     for a bond with a coupon structure in which the first or last period is
%     either normal, short, or long (i.e. regardless of whether the coupon 
%     structure is synched to maturity or not). In the case of zero coupon 
%     bonds this function returns the theoretical previous quasi coupon date
%     (i.e. the previous coupon date that would prevail if the bond were a 
%     coupon bond).
%
%     PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis,...
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
% Outputs: PreviousCouponDate - Previous actual coupon date
%         
%         Outputs are NUMBONDS by 1 vectors
%
%         If the settlement date is a coupon date, this function always 
%         returns the settlement date.
%
%See Also: CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%          CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES

%Copyright 1995-2002 The MathWorks, Inc.
%$Revision: 1.18 $ $Date: 2002/04/14 21:50:05 $

%
% *** Start of code replication of cpndatepq().
%

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
zeroCouponBonds = (Period == 0);
Period(zeroCouponBonds)  =  2;

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

%
% *** End of code replication of cpndatepq().
%

PreviousCouponDate = PreviousQuasiCouponDate;

%
% Check for Zero Coupon Bonds (ZCB). If settlement date is on maturity date, the previous 
% coupon date is the maturity date. If settlement is before maturity date and issue date 
% IS available, the previous coupon date is the issue date.  However, if issue date is 
% NOT available, the previous date is the previous quasi coupon date.
%
if any(zeroCouponBonds),

    if all(~isnan(IssueDate)),
        if any(Settle >= IssueDate & Settle < Maturity),
            dateidx = (zeroCouponBonds & ~isnan(IssueDate)   & CouponRate == 0 & ...
                       Settle >= IssueDate & Settle < Maturity);
            PreviousCouponDate(dateidx) = IssueDate(dateidx);
        else,
            dateidx = (zeroCouponBonds & isnan(IssueDate)    & CouponRate == 0 & ...
                       Settle >= IssueDate & Settle < Maturity);
            PreviousCouponDate(dateidx) = PreviousQuasiCouponDate(dateidx);
        end
    end
    
end

%
% Previous Coupon date scenarios for non-ZCB:
%
%    If Previous Coupon Date is:          Then:
%
% 0. Before Issue Date,                   Set Previous Coupon Date equal to
%                                         Issue Date.
%
%    If Settlement date is:               Previous Coupon date is on:
%
% 1. Before First Coupon date,            Issue date or previous quasi coupon,
%                                         if Issue date is not available.
% 2. On First Coupon date,                First Coupon date.
% 3. After First Coupon date and          First Coupon date.
%    before Second Coupon date,
% 4. Before Last Coupon date and          Second to Last Coupon date.
%    second to Last Coupon date,  
% 5. On Last Coupon date,                 Last Coupon date.
% 6. After Last Coupon date and           Last Coupon date.
%    before Maturity,
%
if any(PreviousCouponDate < IssueDate),
    dateidx = (~zeroCouponBonds & PreviousCouponDate < IssueDate);
    PreviousCouponDate(dateidx) = IssueDate(dateidx);
end

if any(Settle < FirstCouponDate),
    dateidx = (~zeroCouponBonds & Settle < FirstCouponDate);
    PreviousCouponDate(~isnan(IssueDate) & dateidx) = IssueDate(~isnan(IssueDate) & dateidx);
    PreviousCouponDate(isnan(IssueDate) & dateidx) = PreviousQuasiCouponDate(isnan(IssueDate) & dateidx);
end

if any(Settle >= FirstCouponDate & Settle < LastCouponDate),
    dateidx = (~zeroCouponBonds & Settle >= FirstCouponDate & Settle < LastCouponDate);
    PreviousCouponDate(dateidx) = PreviousQuasiCouponDate(dateidx);
end

if any(Settle >= LastCouponDate),
    dateidx = (~zeroCouponBonds & Settle >= LastCouponDate);
    PreviousCouponDate(dateidx) = LastCouponDate(dateidx);
end

%
% Previous Coupon date scenarios for all:
%
%    If Settlement date is:               Previous Coupon date is on:
%
% 7. On Maturity,                         Maturity.
%
if any(Settle == Maturity),
    dateidx = (CouponRate ~= 0 & Settle == Maturity);
    PreviousCouponDate(dateidx) = Maturity(dateidx);
end

return
