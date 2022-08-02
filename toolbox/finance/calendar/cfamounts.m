function [CFAmounts, CFDates, CFTimes, CFFlags] = cfamounts(varargin)
%CFAMOUNTS Cash flow and time mapping for each bond of a portfolio.
%   CFAMOUNTS returns the cash flows, dates when cash flows occur, and the times
%   suitable for discounting semi-annual coupons.
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(CouponRate, ...
%       Settle, Maturity)
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(CouponRate, ...
%       Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
%       FirstCouponDate, LastCouponDate, StartDate, Face)
%
%   Optional Inputs: Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,
%                    LastCouponDate, StartDate, Face
%
%   Inputs: [Scalar or vector of size NBONDS x 1]
%   CouponRate - Decimal coupon rate; 0 for zero coupon bonds.
%
%       Settle - Settlement date.
%
%     Maturity - Maturity date.
%
%   Optional Inputs: [Scalar or vector of size NBONDS x 1]
%            Period - Coupon frequency. The default is semi-annual (2).
%
%             Basis - values specifying the basis for each bond in the portfolio.
%
%                     Possible values are:
%                     0 - actual/actual (default)
%                     1 - 30/360 (SIA compliant)
%                     2 - actual/360
%                     3 - actual/365
%
%      EndMonthRule - End of month rule. The default is "1" meaning "in effect".
%
%         IssueDate - Date of issue
%
%   FirstCouponDate - First actual coupon date.
%
%   LastCouponDate  - Last actual coupon date.
%
%         StartDate - Starting date (Argument reserved for future
%                     implementation).
%
%              Face - Face value. The default is 100.
%
%   Outputs: Outputs are NBONDS by NCFS matrices. Each row lists the cash flows
%            for a particular bond. Shorter rows are padded with the value NaN.
%
%   CFlowAmounts - Cash flow amounts. First entry in each row vector is the
%                  (negative) accrued interest due at settlement.  If no accrued
%                  interest is due, the first column is zero.
%
%     CFlowDates - Cash flow dates in serial date number form.  At least two
%                  columns are always present: one for settlement and one for
%                  maturity.
%
%       TFactors - Time factor for SIA semi-annual price/yield conversion:
%                  DiscountFactor = (1 + Yield/2).^(-TFactor).  Time factors are
%                  in units of semi-annual coupon periods.
%
%     CFlowFlags - Cash flow flags indicating the type of payment.  Type
%                  "help ftbcflowflags" for a description of possible values.

% Author(s): Bassignani, 22-Jan-98, Akao 29-Jan-99, Winata 30-Aug-2002
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.26.2.3 $   $Date: 2004/04/06 01:06:20 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%           ************* GET/PARSE INPUT(S) **************             %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Checking the input arguments and set defaults
if (nargin < 3)
    error('Finance:cfamounts:tooFewInputs', ...
        'Enter Coupon Rate, Settle, Maturity.');
end

% There are no default values for settle or maturity.
% Check to see if either or both settle and maturity are empty;
% if so set the output matrices to empties and return
if (isempty(varargin{2}) || isempty(varargin{3}))
    CFlowAmounts = [];
    CFlowDates = [];
    TFactors = [];
    CFlowFlags = [];

    return
end

[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
    IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face] = ...
    instargbond(varargin{:});

% Record which outputs are requested
CFDatesRequest = (nargout >= 2);
CFTimesRequest = (nargout >= 3);
CFFlagsRequest = (nargout >= 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%             ************* GENERATE OUTPUT(S) **************            %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the number of bonds in the portfolio
NumBonds = size(Settle, 1);

% Hit all the semi-annual dates when period is 0, 1, or 3
CommonPeriod = Period;
CommonPeriod(Period==3) = 6;
CommonPeriod(Period==1) = 2;
CommonPeriod(Period==0) = 2;

%----------------------------------------------------------------------------
% Create padded date matrix (Settle - 1 year , MD + 1 year]
% CommonPeriod : Always has semi-annual dates (P=1,3,0)
%
% PadCFDates : [NumBonds x PadCFCols] Padded common period quasi-dates
%              (Not including an unsynced maturity)
%----------------------------------------------------------------------------
% Create a padded matrix of coupon dates to figure time factors
% Roll back 1 year from Settlement in Acutal/Acutal basis
% Roll forward to get at least 1 semi-annual coupon date after Maturity

NumEarlyDates = CommonPeriod;
NumLateDates = CommonPeriod;
PadCFDates = cfdatesq(Settle, Maturity, ...
    CommonPeriod, Basis, EndMonthRule, ...
    [], FirstCouponDate, LastCouponDate, ...
    NumEarlyDates, NumLateDates);

% Get the size of the Padded matrix
[NumBonds, PadCFCols] = size(PadCFDates);

%----------------------------------------------------------------------
% Create a mask of the actual dates and some bond-by-bond flags
%
% PadCFMask [NumBonds x PadCFCols] 1 if an actual cash flow date
% PadQDMask [NumBonds x PadCFCols] 1 if a c.f. quasi-date
%
% BondIsMatSynced [NumBonds x 1] 1 if maturity is synced
% BondIsZero      [NumBonds x 1] 1 if bond is a zero
% BondSkipsCFs    [NumBonds x 1] 1 if quasi-dates alternate in PadCFDates
% BondInLast      [NumBonds x 1] 1 if bond settles in last period
%
%----------------------------------------------------------------------
PadCFMask = logical(ones(NumBonds, PadCFCols));

% Kill entries which have no corrsponding date
PadCFMask( isnan(PadCFDates) ) = 0;

% Kill dates after the actual maturity date
PadCFMask( PadCFDates > Maturity(:,ones(1,PadCFCols)) ) = 0;

% Kill dates after the actual last coupon date except maturity
if (~all(isnan(LastCouponDate)))
    AfterLCMask = ( PadCFDates > LastCouponDate(:,ones(1,PadCFCols)) );
    MaturityMask = ( PadCFDates == Maturity(:,ones(1,PadCFCols)) );

    PadCFMask( AfterLCMask & ~MaturityMask ) = 0;
end

% Kill dates before the actual first coupon date
if (~all(isnan(FirstCouponDate)))
    PadCFMask( PadCFDates < FirstCouponDate(:,ones(1,PadCFCols)) ) = 0;
end

% Kill dates before the actual starting Date
if (~all(isnan(StartDate)))
    PadCFMask( PadCFDates < StartDate(:,ones(1,PadCFCols)) ) = 0;
end

% For zeros, kill dates before maturity
BondIsZero = ( Period==0 );
ZeroMask = BondIsZero(:, ones(1,PadCFCols));
PadCFMask( ZeroMask & (PadCFDates < Maturity(:,ones(1,PadCFCols))) ) = 0;

% Remove alternating dates
BondSkipsCFs = ( (2*Period) == CommonPeriod );

% For Annual and Tri-annual bonds, every other time factor is not a
% quasi coupon date.  In cases where the coupon structure is synced to
% maturity and there is no odd last period, valid entries alternate
% back from maturity.  Otherwise you need to check if dates with
% CommonPeriod are actually coupon dates.
PadQDMask = logical(ones(NumBonds, PadCFCols));

if any(BondSkipsCFs)
    % If no first nor last coupon date is specified, LateMaturity is always
    % synced to the coupon structure
    BondCheckSync = (~isnan(FirstCouponDate) | ~isnan(LastCouponDate));

    % Alternate back from the Maturity date if it is safe
    % An estimate of where is the Maturity date is only good for assuredly
    % Maturity synced bonds.  Otherwise Maturity could show up as a
    % quasi-coupon if First/LastCouponDate was 1/2 period off Maturity.
    % PadQDMask( BondSkipsCFs & ~BondCheckSync , end-1:-2:1 ) = 0;

    % Check the first date otherwise
    % CkInd = find(BondSkipsCFs & BondCheckSync);
    CkInd = find(BondSkipsCFs);
    if ~isempty(CkInd)
        RealQuasiDate = cpndatepq(PadCFDates(CkInd,1), Maturity(CkInd), ...
            Period(CkInd), Basis(CkInd), EndMonthRule(CkInd), [], ...
            FirstCouponDate(CkInd), LastCouponDate(CkInd));

        % The fake coupons are 2,4,6, ... if RealQuasiDate(i) == PadCFDates(i,1)
        I = (RealQuasiDate == PadCFDates(CkInd,1));
        PadQDMask( CkInd(I) , 2:2:end ) = 0;

        % The fake coupons are 1,3,5, ... if RealQuasiDate(i) ~= PadCFDates(i,1)
        I = (RealQuasiDate ~= PadCFDates(CkInd,1));
        PadQDMask( CkInd(I) , 1:2:end ) = 0;
    end
end

% Remove alternating dates from the actual cash flow dates
PadCFMask( ~PadQDMask ) = 0;

% Look for the maturity date in the padded matrix after alternates are gone
CFMask = PadCFMask & ( PadCFDates == Maturity(:,ones(1,PadCFCols)) );
BondIsMatSynced = any( CFMask  , 2 );

% Kill dates on or before the actual settlement
% You do not get the cash flow on settlement
PadCFMaskNoSettle = PadCFMask;
PadCFMask( PadCFDates <= Settle(:,ones(1,PadCFCols)) ) = 0;

% Check if there are any actual cash flow dates strictly before Maturity
% Bond settles in the last period if there are none
CFMask = PadCFMask & ( PadCFDates < Maturity(:,ones(1,PadCFCols)) );
BondInLast = ~any( CFMask, 2 );

%----------------------------------------------------------------------
% Create indices to change the padded matrices to non-padded matrices
%
% NumCFCols       [scalar] The squeezed matrices are NumBonds x NumCFCols
%                 after adding the accrued interest row.
%
% PadSqueezeMap   [NumEntries x 1]    : quasi-date cash flows
% SqeezeMap       [NumEntries x 1]    : quasi-date cash flows
% AddMatMap       [NumNonSynced x 1]  : non-synced maturity only
% BondAddMatMap   [NumNonSynced x 1]  : non-synced maturity only
% MatMap          [NumBonds x 1]      : all maturity
%
% For example, consider PadCFDates, CFDates, CFAmounts, Maturity, Settle, Face
% PadCFDates [NumBonds x PadCFCols]
% CFDates    [NumBonds x NumCFCols]
% CFAmounts  [NumBonds x NumCFCols]
% Maturity   [NumBonds x 1]
% Settle     [NumBonds x 1]
% Face       [NumBonds x 1]
%
% CFDates(:,1)        = Settle
% CFDates(SqueezeMap) = PadCFDates(PadSqueezeMap)
% CFDates(AddMatMap)  =   Maturity(BondAddMatMap)
%
% CFAmounts(MatMap) = CFAmounts(MatMap) + Face;
%
%----------------------------------------------------------------------

% Row and column within the Padded matrix (at locations in padded)
[RowInd, PadColInd] = ndgrid(1:NumBonds, 1:PadCFCols);

% Rows stay the same within the squeezed matrix
% column within the squeezed matrix (at locations in padded)
% coluns are shifted back 1 to make room for accrued interest
ColInd = 1 + cumsum( PadCFMask , 2 );

% Create the mappings for all locations in padded
PadSqueezeMap = RowInd + NumBonds*(PadColInd - 1);
SqueezeMap = RowInd + NumBonds*(   ColInd - 1);

% Sample the mappings only where there is a real cash flow
PadSqueezeMap = PadSqueezeMap( PadCFMask );
SqueezeMap =    SqueezeMap( PadCFMask );

% Find out how many columns there are in the squeezed matrix
% Add one column if maturity is not in the padded matrix, unless maturity
% is excluded because settle falls on maturity
MaturityCol = ColInd(:,end) + ( ~BondIsMatSynced & (Settle ~= Maturity) );

% Find out where maturity would go in the squeezed matrix
MatMap = (1:NumBonds)' + NumBonds*(MaturityCol - 1);

% Sample the mapping only where there is unsynced maturity
AddMatMap = MatMap(~BondIsMatSynced);
BondAddMatMap = find(~BondIsMatSynced);

% Record the number of columns in the squeezed matrix
NumCFCols = max(MaturityCol);

%----------------------------------------------------------------------
% Parse conditions for possible irregular first period, last period, and
% accrued interest fraction
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Check if the bond settles in an irregular first period.
% Period is [IssueDate, CF1D] where CF1D is the first cash flow date
% strictly after Settlement
% We will need quasi-date before CF1D to check.
%
% settling in a long periods bounded by last coupon date is handled later
%
% BondHasCF1 [NumBonds x 1] : 1 if bond settles in an irregular first period
% CF1Flag : [NumBonds x 1] : CFlowFlag indicating status of irreg. CF1
%
% CF1D [NumBonds x 1] : First cash flow date after Settle
% CF1BackQD   [NumBonds x 1] : quasi-date before CF1D
%
% CF1BackQCol [NumBonds x 1] : column of CF1BackQD in PadCFDates
% CF1BackQInd [NumBonds x 1] : Index of CF1BackQD in PadCFDates
%
% CF1Col [NumBonds x 1] : column of CF1D in PadCFDates
% CF1Ind [NumBonds x 1] : Index of CF1D in PadCFDates
%
% IPrevQD [NumBonds x 1] : quasi-date <= Issue
% INextQD [NumBonds x 1] : quasi-date > Issue
%
% CF1QDates [(CF1Flag==2) x CFMCols] : extra quasi-dates from
% [INextQD to FirstCouponDate] to count periods in long last
%----------------------------------------------------------------------

% No special flags or dates are needed by default
CF1Flag = NaN*ones(NumBonds,1);
CF1D = NaN*ones(NumBonds,1);
CF1BackQD = NaN*ones(NumBonds,1);

% Determine if an irregular first period exists
BondHasCF1 = logical( ones(NumBonds,1) );

% Zeros are out
BondHasCF1(BondIsZero) = 0;

% Issue date must be present to consider an irregular first period
BondHasCF1(isnan(IssueDate)) = 0;

% Check dates to determine nature of first period after settlement
if any(BondHasCF1)

    % Sweep for the location of the first cash flow entry
    CF1Col = NaN*ones(NumBonds,1);
    CF1Col(BondHasCF1) = findfirst(PadCFMask(BondHasCF1,:), 2);

    % Mark if there was no cash flows
    % (Settle==Maturity or unsynced last period)
    BondHasCF1(isnan(CF1Col)) = 0;

    % The periodic quasi-date before the first cash flow date is located
    % either 1 or 2 back before the first cash flow date
    CF1BackQCol = CF1Col - 1 - BondSkipsCFs;

    % Use indices to extract the dates
    CF1Ind      = (1:NumBonds)' + NumBonds*(CF1Col - 1);
    CF1BackQInd = (1:NumBonds)' + NumBonds*(CF1BackQCol - 1);

    % Get the date where applicable
    CF1BackQD(BondHasCF1) = PadCFDates( CF1BackQInd(BondHasCF1) );
    CF1D(BondHasCF1)      = PadCFDates( CF1Ind(BondHasCF1) );

    % Check for a short first period (NaN comps always false)
    CF1Flag( IssueDate > CF1BackQD ) = 1;

    % Check for a long first period bounded by Issue
    CF1Flag( ( IssueDate < CF1BackQD ) & (FirstCouponDate==CF1D) ) = 2;

    % Update mask for irregular first period
    BondHasCF1 = ~isnan(CF1Flag);

end

% Get a bracket around Issue Date if the bond settles in an irregular
% first period.
IPrevQD = NaN*ones(NumBonds,1);
INextQD = NaN*ones(NumBonds,1);
if any(BondHasCF1)
    % look at short periods: bracketed by [CF1BackQD, CF1D]
    IPrevQD(CF1Flag==1) = CF1BackQD(CF1Flag==1);
    INextQD(CF1Flag==1) = CF1D(CF1Flag==1);

    % look at long periods
    Ind = (CF1Flag==2);
    if any(Ind)
        IPrevQD(Ind) = cpndatepq(IssueDate(Ind), Maturity(Ind), ...
            Period(Ind), Basis(Ind), EndMonthRule(Ind), ...
            [], FirstCouponDate(Ind), LastCouponDate(Ind));

        % compute extra quasi dates only when there is a long first period.
        CF1QDates = cfdates(IssueDate(Ind), FirstCouponDate(Ind), ...
            Period(Ind), Basis(Ind), EndMonthRule(Ind));

        % grab the quasi-date strictly after issue from CF1QDates
        INextQD(Ind) = CF1QDates(:,1);
    end

end

%----------------------------------------------------------------------
% Check if the bond has an irregular last period before maturity.
% If Maturity is synced to the coupon structure,
% 1) Issue date can create a short period, [IssueDate, Maturity] or
% 2) LastCouponDate can create a long period, [LastCouponDate, Maturity]
%
% If Maturity is not synced to the coupon structure, the last period is
% 1) short if the quasi-date before maturity is actually a c.f. date
%    [CFEndQ, Maturity]
% 2) long if the quasi-date is not a c.f. date [LastCouponDate, Maturity]
%
% BondHasCFM  [NumBonds x 1] : 1 if bond has an irregular last period
% CFMFlag : [NumBonds x 1] : CFlowFlag indicating status of Maturity cf
%
% Maturity is bracketed by CFMPrevQD and CFMNextQD
% If BondIsMatSynced = 1, CFMBackQD < CFMPrevQD = Maturity < CFMNextQD
% If BondIsMatSynced = 0, CFMBackQD = CFMPrevQD < Maturity < CFMNextQD
%
% CFMBackQD     [NumBonds x 1] : last quasi-date strictly before maturity
% CFMPrevQD     [NumBonds x 1] : last synced quasi-date <= maturity
% CFMNextQD     [NumBonds x 1] : first synced quasi-date > maturity
%
% CFMQDates [NumBonds x CFMCols] : extra quasi-dates from
% [LastCouponDate to CFMNextQD] to count periods in long last
% Rows are NaN unless CFMFlag=6
%----------------------------------------------------------------------

% Get columns of quasi-dates; Maturity location is needed for cf & flag
CFMask = PadQDMask & ( PadCFDates > Maturity(:,ones(1,PadCFCols)) );
CFMNextCol = findfirst( CFMask , 2 );

% Back up one quasi-period for the bracket
CFMPrevCol = CFMNextCol - (1 + BondSkipsCFs);

% Only back up again if Maturity==CFMPrevCol.
CFMBackCol = CFMPrevCol - (1 + BondSkipsCFs).*BondIsMatSynced;

% Compute indices for quasi-dates
CFMNextInd = (1:NumBonds)' + NumBonds*(CFMNextCol - 1);
CFMPrevInd = (1:NumBonds)' + NumBonds*(CFMPrevCol - 1);
CFMBackInd = (1:NumBonds)' + NumBonds*(CFMBackCol - 1);

% Pull out the quasi-dates themselves
CFMNextQD = PadCFDates( CFMNextInd );
CFMPrevQD = PadCFDates( CFMPrevInd );
CFMBackQD = PadCFDates( CFMBackInd );

% Usual flag is 4/7, short 5/8, long 6/9
CFMFlag = 4*ones(NumBonds,1);

% Determine if an irregular last period exists
BondHasCFM = logical( ones(NumBonds,1) );

% Zeros are out
BondHasCFM(BondIsZero) = 0;

% At least one of First, Last, or Issue date is required to create an
% irregular last period.
BondHasCFM( all(...
    isnan([ IssueDate, FirstCouponDate, LastCouponDate ]) , 2) ) = 0;

% Look for short periods bounded by Issue
Ind = (BondHasCFM & BondIsMatSynced & (IssueDate > CFMBackQD) );
if any(Ind)
    CFMFlag(Ind) = 5;
end

% Look for long periods bounded by issue
Ind = ( (IssueDate < CFMBackQD) & (FirstCouponDate == Maturity) );
if any(Ind)
    CFMFlag(Ind) = 6;
end

% Look for short periods bounded by a cash flow
Ind = (BondHasCFM & ~BondIsMatSynced & PadCFMaskNoSettle(CFMPrevInd));
if any(Ind)
    CFMFlag(Ind) = 5;
end

% Look for long periods bounded by last
Ind = ( BondHasCFM & (LastCouponDate < CFMBackQD) );
if any(Ind)
    CFMFlag(Ind) = 6;

    % Create extra quasi-dates only for long last period to count the
    % number of whole periods before a maturity fraction
    CFMQDates = cfdates(LastCouponDate(Ind), CFMNextQD(Ind), ...
        Period(Ind), Basis(Ind), EndMonthRule(Ind));
end

% Update the cases where the last period is irregular
BondHasCFM( CFMFlag==4 ) = 0;

% Adjust the flags if the bond is in it's last period
CFMFlag = CFMFlag + 3*BondInLast;

% Zeros are marked with 10
CFMFlag(BondIsZero) = 10;

%----------------------------------------------------------------------
% Check if accrued interest is regular
% Get a quasi-date bracket around settlement
%
% SPrevQD [NumBonds x 1] : quasi-date <= Settle
% SNextQD [NumBonds x 1] : quasi-date > Settle
%
%----------------------------------------------------------------------
CFMask = PadQDMask & ( PadCFDates > Settle(:,ones(1,PadCFCols)) );
SNextCol = findfirst( CFMask, 2 );
SPrevCol = SNextCol - ( 1 + BondSkipsCFs );

SNextInd = (1:NumBonds)' + NumBonds*(SNextCol - 1);
SPrevInd = (1:NumBonds)' + NumBonds*(SPrevCol - 1);

SPrevQD = PadCFDates( SPrevInd );
SNextQD = PadCFDates( SNextInd );

%----------------------------------------------------------------------
% Compute quantities
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% AICoupon = Face * CouponRate / Period;
% NominalCoupon = Face * CouponRate / Period (*)
%
% *For annual bonds actual/360, adjust the nominal coupon by 365/360
%----------------------------------------------------------------------
NominalCoupon = zeros(NumBonds,1);

% look at non-zero, non-nan coupon rates
Ind = ~BondIsZero & (CouponRate ~= 0);
NominalCoupon(Ind) = Face(Ind) .* CouponRate(Ind) ./Period(Ind);

AICoupon = NominalCoupon;

Ind = (Period==1 & Basis==2);
NominalCoupon(Ind) = NominalCoupon(Ind)*365/360;
%----------------------------------------------------------------------
% Accrued Interest
% AIFrac     [NumBonds x 1] = SettleFrac - IssueFrac + AIPeriods;
% SettleFrac [NumBonds x 1] : fraction of quasi-period before settle
% IssueFrac  [NumBonds x 1] : fraction of quasi-period before issue
% AIPeriods  [NumBonds x 1] : whole quasi-periods before settle
%----------------------------------------------------------------------

SettleFrac = zeros(NumBonds,1);
IssueFrac = zeros(NumBonds,1);
AIPeriods = zeros(NumBonds,1);

% SettleFrac is always needed as long as the bond is not a zero
% SPrevQD <= Settle < SNextQD
Ind = (NominalCoupon ~= 0);
if any(Ind)
    SettleFrac(Ind) = daysaccru(SPrevQD(Ind),  Settle(Ind), Basis(Ind)) ./ ...
        dayspersz(SPrevQD(Ind), SNextQD(Ind), Basis(Ind), Period(Ind));
    daysaccru(SPrevQD(Ind), SNextQD(Ind), Basis(Ind));
end

% If Settle is in an irregular period created by issue,
% IPrevQD and INextQD have been created.
% IPrevQD <= Issue < INextQD
Ind = BondHasCF1;
if any(Ind)
    IssueFrac(Ind) = daysaccru(IPrevQD(Ind), IssueDate(Ind), Basis(Ind)) ./ ...
        dayspersz(IPrevQD(Ind), INextQD(Ind),   Basis(Ind), Period(Ind));
    daysaccru(IPrevQD(Ind), INextQD(Ind),   Basis(Ind));
end

% If the first period is long, there could be extra periods
% Issue < CF1QDates(:,1)
Ind = (CF1Flag==2);
if any(Ind)

    CFMask = CF1QDates <= Settle(Ind, ones(1,size(CF1QDates,2)));
    AIPeriods(Ind) = sum( CFMask , 2 );
end

% There could also be a long period when lastcoupondate < settle
Ind = ( CFMFlag==9 );
if any(Ind)
    CFMask = CFMQDates(Ind,:) <= Settle(Ind, ones(1,size(CFMQDates,2)));
    AIPeriods(Ind) = sum( CFMask , 2 );
end

% Compute AI Fraction
AIFrac = SettleFrac - IssueFrac + AIPeriods;

% Compute Accrued interest
% AccruedInterest = AICoupon .* AIFrac;
AccruedInterest = (SettleFrac - IssueFrac) .* AICoupon + ...
    AIPeriods .* NominalCoupon;

%----------------------------------------------------------------------
% First coupon payment before maturity
% Use the default values unless the payment is irregular (BondHasCF1).
% CF1Coupon  [NumBonds x 1] First coupon ammount
% CF1Frac    [NumBonds x 1] = -IssueFrac + CF1Periods;
% IssueFrac  [NumBonds x 1] : fraction of quasi-period before issue
% CF1Periods [NumBonds x 1] : whole quasi-periods before first coupon
%----------------------------------------------------------------------

% IssueFrac is already computed in an irregular period
% IssueFrac already is set to zero otherwise

% There is normally 1 period elapsed in this coupon period
CF1Periods = ones(NumBonds,1);

% count long first periods
% CF1QDates is built IssueDate < CF1QDates <= FirstCouponDate
Ind = (CF1Flag==2);
if any(Ind)
    CF1Periods(Ind) = sum( ~isnan(CF1QDates) , 2 );
end

% compute first period fraction good for all bonds
CF1Frac = CF1Periods - IssueFrac;

% compute first coupon amount
% CF1Coupon = NominalCoupon .* CF1Frac;
CF1Coupon = CF1Periods.*NominalCoupon - IssueFrac.*AICoupon;
%----------------------------------------------------------------------
% Coupon payment at maturity
% Non-issue bounded last periods are of length:
% CFMFrac = CFMPeriods - MaturityFrac
%
% Issue-bounded last period coupons are taken from CF1Coupon.
%
% In last period bounded by
% use default parameters
%
%----------------------------------------------------------------------

MaturityFrac = zeros(NumBonds,1);
CFMPeriods = ones(NumBonds,1);

% Pick up non-issue bounded irregular last periods
Ind = ( BondHasCFM & ~(BondHasCF1 & BondInLast) );
if any(Ind)
    % Find time in period cut off by early maturity
    MaturityFrac(Ind) = daysaccru(Maturity(Ind),  CFMNextQD(Ind), Basis(Ind)) ...
        ./    dayspersz(CFMPrevQD(Ind), CFMNextQD(Ind), Basis(Ind), Period(Ind));

    % if the period is long, count whole periods after last coupon date
    IndLongLast = (Ind & ( CFMFlag==6 | CFMFlag==9 ));
    if any(IndLongLast)
        CFMPeriods(IndLongLast) = sum(~isnan(CFMQDates), 2);
    end
end

% Compute last period fraction good everywhere except issue-bounded
% irregular last (same as first) periods.
CFMFrac = CFMPeriods - MaturityFrac;
CFMCoupon = NominalCoupon .* CFMFrac;

% In last period bounded by Issue if bond settles in its irregular first and
% the bond settles in the last period.  In that case, the first period
% and last period are the same, and first period is already computed.
Ind = ( BondHasCFM & (BondHasCF1 & BondInLast) );
if any(Ind)
    CFMCoupon(Ind) = CF1Coupon(Ind);
end

%----------------------------------------------------------------------
% Create padded cfamounts matrix
% PadCFAmounts [NumBonds x PadCFCols]
%----------------------------------------------------------------------

% Start with the nominal coupon
PadCFAmounts = NominalCoupon(:,ones(1,PadCFCols));

% Write in any special first coupon payment falling before Maturity
Ind = BondHasCF1 & ~BondInLast;
if any(Ind)
    PadCFAmounts( CF1Ind(Ind) ) = CF1Coupon(Ind);
end

%----------------------------------------------------------------------
% Create final cfamounts matrix
% Write in maturity directly
% Add accrued interest
%----------------------------------------------------------------------
CFAmounts = NaN*ones(NumBonds, NumCFCols);

% Write in coupons before maturity
CFAmounts(SqueezeMap) = PadCFAmounts(PadSqueezeMap);

% Write in maturity amount
CFAmounts(MatMap) = Face + CFMCoupon;

% Include negative accrued interest
CFAmounts(:,1) = -AccruedInterest;

% Use a convention that when Settle==Maturity, the settlement value is
% copied to the second column.  No coupon is paid, but you do get Face.
% This may expand the matrix columns
CFAmounts(Settle==Maturity,2) = Face(Settle==Maturity);

%----------------------------------------------------------------------
% Create final cfdates matrix if requested
% Write in unsynced maturity
%----------------------------------------------------------------------
if CFDatesRequest
    CFDates = NaN*ones(NumBonds, NumCFCols);

    % Write in dates before maturity
    CFDates(SqueezeMap) = PadCFDates(PadSqueezeMap);

    % Write in maturity date
    CFDates(MatMap) = Maturity;

    % Include settlement for accrued interest
    CFDates(:,1) = Settle;

    % Use a convention that when Settle==Maturity, the settlement value is
    % copied to the second column.
    % This may expand the matrix columns
    CFDates(Settle==Maturity,2) = Settle(Settle==Maturity);
end

%----------------------------------------------------------------------
% Create padded cflowflags matrix if requested
%----------------------------------------------------------------------
if CFFlagsRequest

    % default is 3: a normal coupon
    PadCFFlags = 3*ones(NumBonds, PadCFCols);

    % Write in any special first coupon flag to a cash flow before maturity
    Ind = BondHasCF1 & ~BondInLast;
    if any(Ind)
        PadCFFlags( CF1Ind(Ind) ) = CF1Flag(Ind);
    end

    %----------------------------------------------------------------------
    % Create final cflowflags matrix if requested
    % Write in maturity and accrued interest
    %----------------------------------------------------------------------
    CFFlags = NaN*ones(NumBonds, NumCFCols);

    % Write in flags before maturity
    CFFlags(SqueezeMap) = PadCFFlags(PadSqueezeMap);

    % Write in maturity flag
    CFFlags(MatMap) = CFMFlag;

    % Include 0 for accrued interest
    CFFlags(:,1) = zeros(NumBonds,1);

    % Use a convention that when Settle==Maturity, the payment value is
    % copied to the second column.
    % This may expand the matrix columns
    CFFlags(Settle==Maturity,2) = 11;
end

if CFTimesRequest

    %----------------------------------------------------------------------
    % Compute Time factors at all entries of PadCFDates
    %
    % All time factors will be correct for the date.  A maturity date
    % or last coupon date not in sync with the coupon structure will
    % not be in the list.
    %
    % Time factors use semi-annual windows and units
    %
    % PrevCol [scalar]: column of semi-annual quasi date previous to settle
    % NextCol [scalar]: column of semi-annual quasi date previous to settle
    %
    % TimeFraction [NumCP x 1]     : fraction in each CommonPeriod for this SyncSet
    % SyncSetCols  [1 x NumTF]     : columns in PadCFDates corresponding to time
    %                                factors in this SyncSet
    % SyncSetFrac  [NumCP x NumTF] : Fraction for each time factor
    % SyncSetUnits [NumCP x NumTF] : whole number for each time factor
    %
    % PastUnits : number of saqd before settle
    %----------------------------------------------------------------------
    PadCFTimes = NaN*ones(NumBonds, PadCFCols);

    % Do each CommonPeriod together
    for CP = [2 4 6 12];

        CPInd = find(CommonPeriod==CP);
        if ( ~isempty(CPInd) )

            PosPeriod = CP/2;
            for SyncSet = 1:PosPeriod,
                % Position of saqd <= settle in PadCFDates
                PrevCol = PosPeriod + SyncSet;

                % Position of saqd > settle in PadCFDates
                NextCol = 2*PosPeriod + SyncSet;

                % Time factor fractions are always computed Actual/Actual
                % Compute DaysElapsed from Settle to the next quasi-date
                DaysElapsed  = daysact(     Settle(CPInd) , ...
                    PadCFDates(CPInd, NextCol) );

                DaysInterval = daysact( PadCFDates(CPInd, PrevCol), ...
                    PadCFDates(CPInd, NextCol) );

                TimeFraction = DaysElapsed./DaysInterval;

                % Find columns for time factor locations
                % The first time factor in the set is at the end of the window
                SyncSetCols = (NextCol:PosPeriod:PadCFCols);
                TimeUnits = (0:length(SyncSetCols)-1);

                % Expand TimeFraction across the columns and Units down the rows
                [SyncSetFrac, SyncSetUnits] = ndgrid(TimeFraction, TimeUnits);

                % Write into the time factor matrix
                PadCFTimes(CPInd, SyncSetCols) = SyncSetFrac + SyncSetUnits;

            end

        end
    end


    %----------------------------------------------------------------------
    % Compute unsynced maturity time factors
    %----------------------------------------------------------------------
    CFMTime = NaN*ones(NumBonds,1);

    Ind = ~BondIsMatSynced;
    if any(Ind)
        % Generate the regular semi-annual coupon structure.
        % Runs from a year before settle to Maturity
        % Two quasi-dates occurr before settle
        MatCFDates = cfdatesq(Settle(Ind), Maturity(Ind), 2, ...
            Basis(Ind), EndMonthRule(Ind), [], ...
            [], [], 2, 0);

        PrevCol = 2; % PosPeriod + SyncSet = 1 + 1

        NextCol = 3; % 2*PosPeriod + SyncSet = 2*1 + 1

        % Time factor fractions are always computed Actual/Actual
        DaysElapsed  = daysact( Settle(Ind) , ...
            MatCFDates(:, NextCol) );

        DaysInterval = daysact( MatCFDates(:, PrevCol), ...
            MatCFDates(:, NextCol) );

        TimeFraction = DaysElapsed./DaysInterval;

        % Count the units out to maturity.  NextCol has a unit of zero.
        TimeUnits = sum(~isnan(MatCFDates), 2) - NextCol;

        CFMTime(Ind) = TimeFraction + TimeUnits;

    end

    %----------------------------------------------------------------------
    % Create final cftimes matrix if requested
    % Write in unsynced maturity and settlement time
    %----------------------------------------------------------------------
    CFTimes = NaN*ones(NumBonds, NumCFCols);

    % Write in Times before maturity
    CFTimes(SqueezeMap) = PadCFTimes(PadSqueezeMap);

    % Write in maturity flag for unsynced maturities
    CFTimes(AddMatMap) = CFMTime(BondAddMatMap);

    % Include 0 for accrued interest
    CFTimes(:,1) = zeros(NumBonds,1);

    % Use a convention that when Settle==Maturity,
    % the settlement value is copied to the second column.
    % This may expand the matrix columns
    CFTimes(Settle==Maturity,2) = 0;
end

return

%----------------------------------------------------------------------------
% Subroutines
%----------------------------------------------------------------------------

function FirstInd = findfirst(X,Dim)
%FINDFIRST Find indices of first occurrance of nonzero elements.
%   I = FINDFIRST(X) returns the index of the first nonzero element of
%   the vector X.  If there are no nonzero elements, I = NaN.
%
%   I = FINDFIRST(X,1) returns the row indices of the first nonzero
%   element in each column of the matrix X.  The result is a row vector.
%
%   J = FINDFIRST(X,2) returns the column indices of the first nonzero
%   element in each row of the matrix X.  The result is a column vector.
%
%   See also FIND.

if nargin<2,
    % This should be the first-non-singleton dimension of X
    Dim = 1;
end

if isempty(X)
    FirstInd = zeros(size(X));
    return
end

X = (X~=0);
FirstInd = sum( cumsum(X,Dim) < 1 , Dim) + 1;
FirstInd( FirstInd > size(X,Dim) ) = NaN;

%----------------------------------------------------------------------
%----------------------------------------------------------------------

function d = daysaccru(d1,d2,basis)
%DAYSACCRU Days between dates for any day count basis.
%       D = DAYSACCRU(D1,D2,BASIS) returns the number of
%       days between D1 and D2 using the given day count
%       basis. Enter dates as serial date numbers or date strings.
%       BASIS is the day-count basis: 0 = actual/actual (default),
%       1 = 30/360, 2 = actual/360, 3 = actual/365

if nargin < 2
    error('Finance:cfamounts:tooFewInputs', ...
        'Please enter D1 and D2.')
end

if ischar(d1) || ischar(d2)
    d1 = datenum(d1);
    d2 = datenum(d2);
end

if nargin < 3
    basis = zeros(size(d1));
end

if ~(all(all(basis <= 3)))
    error('Finance:cfamounts:invalidBasis', ...
        'Invalid day count basis specified.')
end
sz = [size(d1);size(d2);size(basis)];

if length(d1) == 1
    d1 = d1*ones(max(sz(:,1)),max(sz(:,2)));
end

if length(d2) == 1
    d2 = d2*ones(max(sz(:,1)),max(sz(:,2)));
end

if length(basis) == 1
    basis = basis*ones(max(sz(:,1)),max(sz(:,2)));
end

if checksiz([size(d1);size(d2);size(basis)],mfilename);
    return;
end

d = zeros(size(d1));

% (0) Actual/Actual, (2) Actual/360, (3) Actual/365
i = find(basis == 0 | basis == 2 | basis == 3);
if ~isempty(i);d(i) = daysact(d1(i),d2(i));end

% (1) 30/360SIA
i = find(basis == 1);
if ~isempty(i);d(i) = days360(d1(i),d2(i));end


%----------------------------------------------------------------------
%----------------------------------------------------------------------

function d = dayspersz(d1,d2,basis,period)
%DAYSPERSZ Days between dates for any day count basis.
%       D = DAYSPERSZ(D1,D2,BASIS) returns the number of
%       days between D1 and D2 using the given day count
%       basis.   Enter dates as serial date numbers or date strings.
%       BASIS is the day-count basis: 0 = actual/actual (default),
%       1 = 30/360, 2 = actual/360, 3 = actual/365

if nargin < 2
    error('Finance:cfamounts:tooFewInputs', ...
        'Please enter D1 and D2.')
end

if ischar(d1) || ischar(d2)
    d1 = datenum(d1);
    d2 = datenum(d2);
end

if nargin < 3
    basis = zeros(size(d1));
end

if ~(all(all(basis <= 3)))
    error('Finance:cfamounts:invalidBasis', ...
        'Invalid day count basis specified.')
end
sz = [size(d1);size(d2);size(basis)];

if length(d1) == 1
    d1 = d1*ones(max(sz(:,1)),max(sz(:,2)));
end

if length(d2) == 1
    d2 = d2*ones(max(sz(:,1)),max(sz(:,2)));
end

if length(basis) == 1
    basis = basis*ones(max(sz(:,1)),max(sz(:,2)));
end

if checksiz([size(d1);size(d2);size(basis)],mfilename);
    return;
end

d = zeros(size(d1));

% Actual/Actual
i = find(basis == 0);
if ~isempty(i);d(i) = daysact(d1(i),d2(i));end

% 30/360, Actual/360
i = find(basis==1 | basis==2);
if ~isempty(i);d(i) = 360./period(i);end

% Actual/365
i = find(basis==3);
if ~isempty(i);d(i) = days365(d1(i),d2(i));end


% [EOF]
