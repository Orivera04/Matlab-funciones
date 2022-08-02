function [CFlowDates, dummy] = cfdates(varargin)
%CFDATES Cash Flow Dates for Fixed Income Securities.
%   This function generates a matrix of actual cash flow payment dates for
%   NUMBONDS fixed income securities. All cash flow dates are determined 
%   regardless of whether the first and last coupon periods are normal, long 
%   or short.
%
%   CFlowDates = cfdates(Settle, Maturity)
%
%   CFlowDates = cfdates(Settle, Maturity, Period, Basis, 
%                        EndMonthRule, IssueDate, FirstCouponDate, 
%                        LastCouponDate)
%   Inputs: 
%     Settle - Settlement date.
%     Maturity - Maturity date.
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2 (semi-annual).
%     Basis - Day-count basis; default is 0 (actual/actual) .
%     EndMonthRule - End-of-month rule; default is 1 (in effect).
%     IssueDate - Bond issue date.
%     FirstCouponDate - First actual coupon date
%     LastCouponDate - Last actual coupon date
%
%   Outputs: 
%     CFlowDates - Matrix of actual cash flow payment dates in serial date 
%       format.  CFlowDates will have NUMBONDS rows, and the number of columns 
%       will be determined by the maximum number of cash flow payment dates
%       required to hold the bond portfolio. NaN's are padded for bonds which
%       have less than the maximum number of cash flow payment dates.
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
%
%   See Also CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%            CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.

% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.26.2.3 $   $Date: 2004/04/06 01:06:21 $

%
% Perform bond input argument checking.
%

[CouponRate    , Settle      , Maturity , Period         , ...
 Basis         , EndMonthRule, IssueDate, FirstCouponDate, ...
 LastCouponDate, StartDate   , Face] = instargbond(0 , varargin{:});

%
% Add error checking to gracefully handle the 'CFlowFlags' second output
% argument originally returned by the previous version of CFDATES.
%

if nargout > 1
   error('CFlowFlags output no longer supported; call CFAMOUNTS instead.');
end

%
% Set payment periodicity of zero-coupon bonds (i.e., Period = 0) to the 
% default semi-annual (i.e., Period = 2) for intermediate calculations.
%

zeroCouponBonds         =  (Period == 0);
Period(zeroCouponBonds) =  2;

%
% Determine the reference (i.e., sync) date. The order of precedence is:
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
% Find the next coupon payment date immediately after settlement.
%

NCD  =  datevec(cpndaten(Settle      , Maturity , Period         , Basis , ...
                         EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate));

%
% Convert reference & maturity dates to (year, month, day) components.
%

referenceVector  =  datevec(referenceDate);
maturityVector   =  datevec(Maturity);

%
% Compute the parameters:
%
%    offsetMonths1 = number of months the next coupon date is offset from the reference date
%    offsetMonths2 = number of months the maturity date is offset from the reference date
%
%    numberPeriods = a 2-column matrix formed from the relative offsets, +/- one period for safety
%
% Negative offsets imply an occurrence before the reference date; positive offsets imply an 
% occurrence after the reference date. 
%

offsetMonths1  =  12*(NCD(:,1) - referenceVector(:,1)) + (NCD(:,2) - referenceVector(:,2));
offsetMonths2  =  12*(maturityVector(:,1) - referenceVector(:,1)) + (maturityVector(:,2) - referenceVector(:,2));

numberPeriods  =  [(floor(offsetMonths1.*Period/12) - 1)  (ceil(offsetMonths2.*Period/12) + 1)];

numberPeriods(zeroCouponBonds,:) =  0;

%
% Size the output date matrix [NUMBONDS-by-max(payment dates)].
%

numberBonds  =  length(Settle);                                         % Number of fixed-income securities.
numberCFlows =  max(numberPeriods(:,2)) - min(numberPeriods(:,1)) + 1;  % Number of cash flow dates.
CFlowDates   =  NaN;
CFlowDates   =  CFlowDates(ones(numberBonds , numberCFlows));

%
% Find the number of months each coupon payment date is offset from the reference date.
%

deltaMonths  =  NaN;
deltaMonths  =  deltaMonths(ones(numberBonds , numberCFlows));

for iBond = 1:numberBonds
    offsetPeriods  = [numberPeriods(iBond,1):numberPeriods(iBond,2)];
    deltaMonths(iBond,1:length(offsetPeriods)) = (12./Period(iBond)) * offsetPeriods; 
end

%
% Expand reference date component to match the size of the output matrix.
%

years  =  referenceVector(:,1);
months =  referenceVector(:,2);
days   =  referenceVector(:,3);

years  =  years (:,ones(size(deltaMonths,2),1));
months =  months(:,ones(size(deltaMonths,2),1));
days   =  days  (:,ones(size(deltaMonths,2),1));

%
% Determine the indicator rule combining the day count basis
% and end-of-month convention (see DATEOFFSET for details).
%

Rule  =  Basis  +  4*(1 - EndMonthRule);
Rule  =  Rule(:,ones(size(deltaMonths,2),1));

%
% Create a Boolean mask matrix indicating which elements 
% of the output matrix to over-write with valid data.
%

mask  =  ~isnan(deltaMonths);

%
% Compute the coupon payment dates and apply the mask to the output.
%

[CpnDay, CpnMonth, CpnYear] =  dateoffset(days , months , years , deltaMonths , Rule);
CFlowDates(mask)            =  datenum(CpnYear(mask) , CpnMonth(mask) , CpnDay(mask));

%
% Enforce some boundary effects:
%
%   (1) If settlement date is before first coupon date, ensure the first 
%       cash flow date of each bond is the first coupon date.
%   (2) Ensure the last cash flow date of each bond is the maturity date.
%   (3) Set all cash flow dates after the last coupon date but before 
%       maturity date to the last coupon date.
%   (4) Flag any cash flow dates on or prior to settlement date as NaN's
%       UNLESS the settlement is on the maturity date. In other words, if
%       settlement occurs on a coupon payment date, the first cash flow 
%       date returned is next actual cash flow date after settlement. If
%       settlement occurs on the maturity date, then return the maturity
%       date as a matter of convention.
%   (5) Set cash flow dates of zero-coupon bonds to the maturity date.
%

columns          =  ones(size(CFlowDates,2),1);

FirstCouponDate  =  FirstCouponDate(:,columns);
LastCouponDate   =  LastCouponDate(:,columns);
Maturity         =  Maturity(:,columns);

CFlowsBeforeFirstCoupon              =  CFlowDates < FirstCouponDate;
CFlowDates(CFlowsBeforeFirstCoupon)  =  FirstCouponDate(CFlowsBeforeFirstCoupon);

CFlowsAfterMaturity                  =  CFlowDates > Maturity;
CFlowDates(CFlowsAfterMaturity)      =  Maturity(CFlowsAfterMaturity);

CFlowsAfterLastAndBeforeMaturity             =  (CFlowDates > LastCouponDate) & (CFlowDates <  Maturity);
CFlowDates(CFlowsAfterLastAndBeforeMaturity) =  LastCouponDate(CFlowsAfterLastAndBeforeMaturity);

CFlowsOnOrBeforeSettle               =  (CFlowDates <= Settle(:,columns)) & (CFlowDates ~= Maturity);
CFlowDates(CFlowsOnOrBeforeSettle)   =  NaN;

CFlowDates(zeroCouponBonds,:)  =  NaN;
CFlowDates(zeroCouponBonds,1)  =  Maturity(zeroCouponBonds);

%
% For each bond, retain only the unique cash flow dates. 
%
% NOTE:
% The code segment below makes explicit use of the fact that the UNIQUE
% function returns the dates sorted in ascending order with NaN's placed
% at the end (very convenient!).
%

for iBond = 1:numberBonds
    [Z , i] = unique(CFlowDates(iBond , :));
    CFlowDates(iBond , 1:length(i))      =  CFlowDates(iBond , i);
    CFlowDates(iBond , length(i)+1:end)  =  NaN;
end

%
% Remove unnecessary columns of the cash flow date matrix with all NaN's.
%

CFlowDates  =  CFlowDates(:,(sum(isnan(CFlowDates),1) ~= numberBonds));