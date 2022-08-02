function QuasiCouponDates = cfdatesq(varargin)
%CFDATESQ Quasi-Coupon Dates for Fixed Income Securities.
%   This function generates a matrix of quasi-coupon dates for NUMBONDS fixed
%   income securities. Successive quasi-coupon dates determine the length of 
%   the standard coupon period for the fixed income security of interest, and
%   do not necessarily coincide with actual coupon payment dates. Quasi-coupon
%   dates are determined regardless of whether the first or last coupon periods
%   are normal, long, or short. By default, quasi-coupon dates after settlement
%   and on or preceding maturity are returned.
%
%   QuasiCouponDates = cfdatesq(Settle, Maturity)
%
%   QuasiCouponDates = cfdatesq(Settle, Maturity, Period, Basis, 
%                               EndMonthRule, IssueDate, FirstCouponDate, 
%                               LastCouponDate, PeriodsBeforeSettle, 
%                               PeriodsAfterMaturity)
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
%     PeriodsBeforeSettle - Number of quasi-coupon dates on or before settlement
%       to include (non-negative integer); default is 0.
%     PeriodsAfterMaturity - Number of quasi-coupon dates after maturity to 
%       include (non-negative integer); default is 0.
%
%   Outputs: 
%     QuasiCouponDates - Matrix of quasi-coupon dates expressed in serial date 
%       format. QuasiCouponDates will have NUMBONDS rows, and the number of 
%       columns is determined by the maximum number of quasi-coupon dates 
%       required to hold the bond portfolio. NaN's are padded for bonds which 
%       have less than the maximum number quasi-coupon dates. By default, quasi-
%       coupon dates after settlement and on or preceding maturity are returned.
%       If settlement occurs on maturity, and maturity is a quasi-coupon date, 
%       then the maturity date is returned.
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
%   See Also CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%            CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.3 $   $Date: 2002/04/14 21:51:36 $ 

%
% Perform bond input argument checking.
%

[CouponRate    , Settle             , Maturity  , Period         , ...
 Basis         , EndMonthRule       , IssueDate , FirstCouponDate, ...
 LastCouponDate, periodsBeforeSettle, periodsAfterMaturity] = instargbond(0 , varargin{:});

%
% Perform some additional input argument checking.
%
% NOTE:
% The 'periodsBeforeSettle' and 'periodsAfterMaturity' output vectors occupy 
% the positions allocated for the 'StartDate' and 'Face' outputs of the
% function INSTARGBOND. Since this function, CFDATESQ, is NOT meant to 
% be a user-callable function, I have gotten lazy and allowed INSTARGBOND
% to perform the argument checking, default assignment, and scalar 
% expansion as necessary. Since the default values, as assigned by 
% INSTARGBOND, for 'StartDate' and 'Face' are NaN and 100, respectively,
% default behavior needs to be over-ridden with zeros.
%

numberBonds  =  length(Settle);    % Number of fixed-income securities.

if nargin <= 8

   periodsBeforeSettle   =  zeros(numberBonds , 1);
   periodsAfterMaturity  =  periodsBeforeSettle;

else

   switch nargin 
      case 9
        periodsAfterMaturity                             =  zeros(numberBonds , 1);
        periodsBeforeSettle(isnan(periodsBeforeSettle))  =  0;

        if any(periodsBeforeSettle < 0)
           error('PeriodsBeforeSettle must be non-negative.');
        end

      case 10
        periodsBeforeSettle(isnan(periodsBeforeSettle))  =  0;             
        periodsAfterMaturity(isnan(periodsAfterMaturity) | (isempty(varargin{10}))) =  0;             

        if any(periodsBeforeSettle < 0)
           error('PeriodsBeforeSettle must be non-negative.');
        end

        if any(periodsAfterMaturity < 0)
           error('PeriodsAfterMaturity must be non-negative.');
        end

   end

end

%
% Set payment periodicity of zero-coupon bonds (i.e., Period = 0) to the 
% default semi-annual (i.e., Period = 2) for intermediate calculations.
%

zeroCouponBonds         =  (Period == 0);
Period(zeroCouponBonds) =  2;

%
% Determine the reference (i.e., sync) date. The order of precedence is:
%
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
% Convert reference date to (year, month, day) components.
%

referenceVector  =  datevec(referenceDate);

%
% Find quasi-coupon dates bracketed by the settlement and maturity dates:
%
%    PQCD = quasi-coupon date on or immediately preceding maturity.
%    NQCD = quasi-coupon date immediately after settlement.
%

PQCD  =  datevec(cpndatepq(Maturity    , Maturity , Period         , Basis , ...
                           EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate));

NQCD  =  datevec(cpndatenq(Settle      , Maturity , Period         , Basis , ...
                           EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate));

%
% Compute the parameters:
%
%    offsetMonths1 = number of months the NQCD is offset from the reference date
%    offsetMonths2 = number of months the PQCD is offset from the reference date
%
%    numberPeriods = a 2-column matrix formed from the relative offsets, adjusted
%                    for any input periods before settlement and after maturity and 
%                    +/- one period for safety.
%
% Negative offsets imply an occurrence before the reference date; positive offsets imply an 
% occurrence after the reference date. 
%

offsetMonths1  =  12*(NQCD(:,1) - referenceVector(:,1)) + (NQCD(:,2) - referenceVector(:,2));
offsetMonths2  =  12*(PQCD(:,1) - referenceVector(:,1)) + (PQCD(:,2) - referenceVector(:,2));

lowerLimits    =  floor(offsetMonths1.*Period/12) - periodsBeforeSettle  - 1;
upperLimits    =  ceil(offsetMonths2.*Period/12)  + periodsAfterMaturity + 1;

numberPeriods  =  [lowerLimits  upperLimits];

%
% Size the output quasi-coupon date matrix [NUMBONDS-by-max(Quasi-coupon payment dates)].
%

numberQCDates     =  max(numberPeriods(:,2)) - min(numberPeriods(:,1)) + 1;  % Number of quasi-coupon dates.
QuasiCouponDates  =  NaN;
QuasiCouponDates  =  QuasiCouponDates(ones(numberBonds , max(numberQCDates)));

%
% Find the number months each quasi-coupon payment date is offset 
% from the first quasi-coupon payment date after settlement.
%

deltaMonths  =  NaN;
deltaMonths  =  deltaMonths(ones(numberBonds , max(numberQCDates)));

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
% Finally, compute the quasi-coupon dates and apply the mask to the output.
%

[CpnDay, CpnMonth, CpnYear] =  dateoffset(days , months , years , deltaMonths , Rule);
QuasiCouponDates(mask)      =  datenum(CpnYear(mask) , CpnMonth(mask) , CpnDay(mask));

%
% For each bond, find the quasi-coupon dates.
%

for iBond = 1:numberBonds

    onOrBeforeSettle =  find(QuasiCouponDates(iBond,:) <= Settle(iBond));
    afterMaturity    =  find(QuasiCouponDates(iBond,:) >  Maturity(iBond));

    if ~isempty(onOrBeforeSettle)
       n1  =  onOrBeforeSettle(end) - periodsBeforeSettle(iBond) + 1;
    else
       n1  =  1;
    end

    n2  =  afterMaturity(1) + periodsAfterMaturity(iBond) - 1;

    n   =  [n1:n2];

    QuasiCouponDates(iBond , 1:length(n))      =  QuasiCouponDates(iBond , n);
    QuasiCouponDates(iBond , length(n)+1:end)  =  NaN;

end

%
% Remove unnecessary columns of the cash flow date matrix with all NaN's.
%

QuasiCouponDates  =  QuasiCouponDates(:,(sum(isnan(QuasiCouponDates),1) ~= numberBonds));