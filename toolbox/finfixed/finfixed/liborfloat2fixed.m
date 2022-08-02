function varargout = liborfloat2fixed(varargin)
%LIBORFLOAT2FIXED Par Fixed-rate of swap from 3-month Libor rates.
%   The function assumes that floating-rate observations occur quarterly on
%   the third-Wednesday of delivery months. The first delivery month is assumed
%   to be the month of the first third-Wednesday after Settle. 
%    
%   Floating-side payments are assumed to be on the third-month anniversaries
%   of observation dates. The output is a "design" of fixed-coupon bonds with
%   present values equal to specified floating rate note. An optional output,
%   the fully adjusted forward rates used to compute the bond, can be returned. 
%
%   Fixed payments start on the same date as the first floating payment, and
%   recurs on the same date as the first-coupon date (on anniversary months).
%
%   [FixedSpec, ForwardDates, ForwardRates] = liborfloat2fixed(ThreeMonthRates, ...
%       Settle, Tenor)
%
%   [FixedSpec, ForwardDates, ForwardRates] = liborfloat2fixed(ThreeMonthRates, ...
%       Settle, Tenor, StartDate, Interpolation, ConvexAdj, RateParam, ...
%       InArrears, Sigma, FixedCompound, FixedBasis)
%
%   Optional Inputs: StartDate, Interpolation, ConvexAdj, RateParam, InArrears,
%                    Sigma, FixedCompound, FixedBasis
%
%   Inputs:
%   ThreeMonthRates - [Nx3] matrix containing 3-month EuroDollar futures data 
%                     or forward rate data in the form of:
%
%                     [Month  Year  IMMQuotation]
%
%                     Example:  [10 2002 98.215;
%                                11 2002 98.205;
%                                12 2002 98.150];
%
%                     Note: The floating rate input is assumed to be QUARTERLY
%                     compounded and accrues with actual/360 basis.
%                     
%                     Quotation must be in the form of:
%                     100 - 100 * [Annualized forward rates in %]
%
%            Settle - [Scalar] value for the settlement date of fixed-rate of
%                     swap.
%
%             Tenor - [Scalar] integer value denoting the life of the contract.
%
%   Optional Inputs:
%        StartDate - [Scalar] value to denote reference date for valuation of 
%                    (forward) swap. This in effect allows forward swap 
%                    valuation. 
%                    Default = Settle
%
%    Interpolation - [Scalar] value for interpolation method to determine
%                    applicable forward rates on the months where no forward
%                    rates are available.
%                       0 - Nearest
%                       1 - Linear (default)
%                       2 - Cubic
%
%        ConvexAdj - [Scalar] value to denote whether futures-forward
%                    convexity adjustment is required.
%                    This adjustment pertains to forward rate adjustments when
%                    those rates are taken from Eurodollar Futures data.
%                       0 - off (default)
%                       1 - on
%
%        RateParam - [1x2] vector to denote the Hull-White short-rate model
%                    parameters ([a S]}.
%                    Default is [0.05 0.015]
%                    
%                    The short-rate process is:
%                       dr = ( f(t) - ar )dt + Sdz
%
%        Inarrears - [Scalar] value to denote whether the swap is in arrears.
%                       0 - off (default)
%                       1 - on.
%
%            Sigma - [Scalar] value to denote annual caplet volatility.
%
%    FixedCompound - [Scalar] value to denote the frequency of payments on the
%                    fixed side.
%                   
%                    Possible values include:
%                        1 - annual
%                        2 - semi annual
%                        4 - quarterly (default)
%                       12 - monthly
%
%       FixedBasis - [Scalar] value to denote the basis of the fixed side.
%                       0 - actual/actual
%                       1 - 30/360 (SIA compliant) (Default)
%                       2 - actual/360
%                       3 - actual/365
%
%   Outputs:
%      FixedSpec - Specification structure of the Fixed-Rate side:
%                  FixedSpec.Coupon   : Par-swap rate
%                  FixedSpec.Settle   : Start of the fixed-rate side
%                  FixedSpec.Maturity : End of the fixed-rate side
%                  FixedSpec.Period   : Frequency of payment of fixed-rate side
%                  FixedSpec.Basis    : Accrual basis of the fixed-rate side
%
%   ForwardDates - Dates corresponding to ForwardRates (all third-Wednesdays of
%                  the month, spread three months apart). The first element is
%                  the third-Wednesday immediately after Settle.
%
%   ForwardRates - Forward rates that correspond to the forward dates,
%                  quarterly compounded, and on the actual/360 basis.
%
%   Example:
%   [EDFutData, textdata] = xlsread('EDdata.xls');
%   Settle                = datenum('15-Oct-2002');
%   Tenor                 = 2;
%
%   [FixedSpec, ForwardDates, ForwardRates] = liborfloat2fixed(EDFutData, ...
%       Settle, Tenor)
%
%   FixedSpec = 
%         Coupon: 0.0222
%         Settle: '16-Oct-2002'
%       Maturity: '16-Oct-2004'
%         Period: 4
%          Basis: 1
%   ForwardDates =
%         731505
%         731596
%         731687
%         731778
%         731869
%         731967
%         732058
%         732149
%   ForwardRates =
%         0.0177
%         0.0166
%         0.0170
%         0.0188
%         0.0214
%         0.0248
%         0.0279
%         0.0305


%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.10.6.5 $ $ Date: 2002/12/12 14:57:50 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Parsing User Input      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin <3
    error('finfixed:liborfloat2fixed:invalidInputs',...
        'Need at least EuroDollarData, Settle, and Tenor.')
else
    EuroData = varargin{1};
    Months   = EuroData(:,1);
    Years    = EuroData(:,2);
    IMMdataF  = EuroData(:,3);

    if any(IMMdataF > 100)
        error('finfixed:liborfloat2fixed:negativeFwdRate',...
            ['Negative forward rate detected.', sprintf('\n') ...
            'Please check your input.'])
    end

    Settle = datenum(varargin{2});
    Tenor = ceil(varargin{3});
end

if nargin<4 || isempty(varargin{4})
    StartDate = Settle;
else
    StartDate = datenum(varargin{4});

    % value check on StartDate
    if StartDate > Settle
        error('finfixed:liborfloat2fixed:invalidStartDate',...
            'StartDate must be less than or equal to Settle.');
    end

end

if nargin<5 || isempty(varargin{5})
    Interpolation = 1;
else
    Interpolation = floor(varargin{5});

    if any(Interpolation ~=0 & Interpolation ~=1 & Interpolation ~=2 )
        error('finfixed:liborfloat2fixed:invalidInterpolation',...
            'Invalid Interpolation method')
    end
end

if nargin<6 || isempty(varargin{6})
    ConvexAdj = 0;
else
    ConvexAdj = floor(varargin{6});
    if any(ConvexAdj~=0 & ConvexAdj~=1)
        error('finfixed:liborfloat2fixed:invalidConvexAdj',...
            'Invalid ConvexAdj method')
    end
end

if nargin<7 || isempty(varargin{7})

    a = 0.05;
    S = 0.015;

else
    RateParam = varargin{7};
    if (numel(RateParam) - 2)
        error('finfixed:liborfloat2fixed:invalidRateParam',...
            'RateParam must be a row or column vector [a S]');
    end

    a = RateParam(1);
    S = RateParam(2);
end


if nargin<8 || isempty(varargin{8})
    Inarrears = 0;
else
    Inarrears = varargin{8};
    if any(Inarrears~=0 & Inarrears~=1)
        error('finfixed:liborfloat2fixed:invalidInarrears',...
            'Invalid Inarrears method')
    end
end

if nargin<9 || isempty(varargin{9})
    Sigma = 0;
else
    Sigma = varargin{9};
end

if nargin<10 || isempty(varargin{10})
    FixComp = 4;
else
    FixComp = floor(varargin{10});

    % Check for allowed compounding
    if any(FixComp ~= 1 & FixComp ~= 2 & FixComp ~= 4 & FixComp ~=12)
        error('finfixed:liborfloat2fixed:invalidFixedCompound',...
            'Invalid FixedCompound specified')
    end
end

if nargin<11 || isempty(varargin{11})
    FixBasis = 1;
else
    FixBasis = floor(varargin{11});

    % check for allowed Basis
    if any(FixBasis ~=0 & FixBasis ~=1 & FixBasis ~=2 & FixBasis ~=3)
        error('finfixed:liborfloat2fixed:invalidFixedBasis',...
            'Invalid FixedBasis specified')
    end
end

if (prod([ size(Settle) size(Tenor) size(StartDate)  size(Interpolation)...
        size(ConvexAdj) size(Inarrears) size(Sigma)...
        size(FixComp) size(FixBasis)]) - 1)
    error('finfixed:liborfloat2fixed:scalarInputs',...
        ['Settle, Tenor, StartDate, Interpolation, ConvexAdj,' ...
        'Inarrears, Sigma, FixedCompound and FixedBasis should '...
        'be scalar.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% FLOATING SIDE CALCULATION                              %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is useful later to get better approximation
% of what Forward Rates should be applied at Settle.

% Construct "raw" data based on user's input
[BgnFwdDatesF EndFwdDatesF] = ...
    thirdwednesday(Months, Years);

%%%%%%%%%%%%%%% DATA INTEGRITY ROUTINE %%%%%%%%%%%%%%%%%%%
%                                                        %
%   1) is Forward data sufficient given Settle           %
%   2) is Forward data sufficient given Tenor            %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% Implementation of 1): Settlement cconsistency          %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Force uniqueness of data, and sort on ascending order:
% at this point it really does not matter particular form
% of implementation - no standard is better than another
[BgnFwdDatesF, m, n] = unique(BgnFwdDatesF);
EndFwdDatesF = EndFwdDatesF(m);
IMMdataF = IMMdataF(m);

datevecSettle = datevec(Settle);
datevecSettleA = datevecSettle;

datevecSettleA(2) = datevecSettleA(2)+1;
datevecSettleA = datenum(datevecSettleA);
datevecSettleA = datevec(datevecSettleA);

% Relevant forward data is that of AFTER Settlement
relevant = find(BgnFwdDatesF>=Settle);

minidx = min(relevant);
minidxtag = 0;

if minidx >1
    minidxtag = 1;
    priorfwdrate = IMMdataF(minidx-1);
    priorfwddate = BgnFwdDatesF(minidx-1);
end

% Redefining Begin, End, and Forward Rate data
% to only contain relevant information.
BgnFwdDates = BgnFwdDatesF(relevant);
EndFwdDates = EndFwdDatesF(relevant);
IMMdata     = IMMdataF(relevant);

% see if that nearest data point is what's supposed to be.
% That is, the "real-world" payment date by
% first computing the two "possible" dates:
[minBgnDate minEndDate]  = ...
    thirdwednesday([datevecSettle(2); datevecSettleA(2)], ...
    [datevecSettle(1); datevecSettleA(1)]);

% If it is not yet this month's third wednesday EXclusive,
% then the next determination date is third wednesday of
% settle's next month
if Settle > minBgnDate(1)
    minBgnDate = minBgnDate(2);
    minEndDate = minEndDate(2);
else
    minBgnDate = minBgnDate(1);
    minEndDate = minEndDate(1);
end

% and see which one is after the settlement
if BgnFwdDates(1) == minBgnDate
    % do nothing, Settle is covered by Forward Data
else %warns and assume Settle is equal to nearest Forward value
    warning('finfixed:liborfloat2fixed:incompleteFwdRate',...
        ['It appears that Forward Rate information is incomplete.', ...
        sprintf('\n') ...
        'Appending data for ', datestr(minBgnDate), ' and assumed', ...
        sprintf('\n') ...
        'rate to be the same as that of the first entry of EuroDollarData.'])

    BgnFwdDates(2:end+1) = BgnFwdDates;
    BgnFwdDates(1) = minBgnDate;

    EndFwdDates(2:end+1) = EndFwdDates;
    EndFwdDates(1) = minEndDate;

    IMMdata(2:end+1)     = IMMdata;

    % minidxtag equals one says that all "relevant" forward data
    % occurs after Settle, but there is al least one prior value
    if minidxtag
        % first look if data is contained within the full-array information
        % so that interpolation would not be needed:
        idx = find(BgnFwdDatesF == BgnFwdDates(1)); % a scalar, due to unique
        % applied to BgnFwdDatesF earlier.

        if ~isempty(idx)
            IMMData(1) = IMMDataF(idx);
        else % the previous data is NOT exactly on the last third-wednesday
            % thus interpolation is needed
            switch Interpolation
                case 0
                    IMMdata(1) = interp1([priorfwddate;BgnFwdDates(2)], ...
                        [priorfwdrate;IMMdata(2)], BgnFwdDates(1), 'nearest');
                case 1
                    IMMdata(1) = interp1([priorfwddate;BgnFwdDates(2)], ...
                        [priorfwdrate;IMMdata(2)], BgnFwdDates(1), 'linear');
                case 2
                    IMMdata(1) = interp1([priorfwddate;BgnFwdDates(2)], ...
                        [priorfwdrate;IMMdata(2)], BgnFwdDates(1), 'cubic');
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% Implementation of 2): Tenor consistency                %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LastReqBgnDate = datevec(minBgnDate);

LastReqBgnDate(2) = LastReqBgnDate(2) + 3*(Tenor*4 - 1);
LastReqBgnDate = datenum(LastReqBgnDate);

dummyvar = datevec(LastReqBgnDate);

LastReqBgnYrs = dummyvar(1);
LastReqBgnMnt = dummyvar(2);

[LastReqBgnDate LastReqEndDate] = ...
    thirdwednesday(LastReqBgnMnt, LastReqBgnYrs);

% If data is not sufficient to cover the last Forward
% rate period, this ensures that the last data is that
% required per LastReqBgnDate
if BgnFwdDates(end) < LastReqBgnDate
    BgnFwdDates(end+1) = LastReqBgnDate(end);
    EndFwdDates(end+1) = LastReqEndDate(end);
    IMMdata(end+1)    = IMMdata(end);
    warning('finfixed:liborfloat2fixed:incompleteFwdRate',...
        ['It appears that Forward Rate information is incomplete.', ...
        sprintf('\n') ...
        'Appending data for ', datestr(BgnFwdDates(end+1)), ' and assumed', ...
        sprintf('\n') ...
        'rate to be the same as that of the first entry of EuroDollarData.']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  TIMING CALCULATION                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The required Begin Data are successive 3-month EuroDollar
% rate starting at minBgnDate
vecminBgnDate = datevec(minBgnDate);

% Tony's trick to expand the single row into a matrix
% of identical rows followed by adding multiple of threes
% into the months.
vecminBgnDate = vecminBgnDate(ones(1,Tenor*4),:);
vecminBgnDate(:,2) = vecminBgnDate(:,2) + 3*(0:(Tenor*4 - 1))';
vecminBgnDate = datenum(vecminBgnDate);

vecminBgnDate = datevec(vecminBgnDate);
vecminBgnMnt = vecminBgnDate(:,2);
vecminBgnYrs = vecminBgnDate(:,1);

[ReqminBgnDate, ReqminEndDate] = ...
    thirdwednesday(vecminBgnMnt, vecminBgnYrs);

% computing Maturity Date for a "fixed" bond.
% applicable if FixBasis is 0,1,4,5,6
vecMatDate    = vecminBgnDate(end,:);
vecMatDate(2) = vecMatDate(2) + 3;
vecMatDate    = datenum(vecMatDate);

switch Interpolation
    case {'Nearest', 'nearest', 'N', 'n', 0}
        if Inarrears
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminEndDate,'n');
        else
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminBgnDate,'n');
        end
    case {'Linear',  'linear',  'L', 'l', 1}
        if Inarrears
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminEndDate,'l');
        else
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminBgnDate,'l');
        end
    case {'Cubic',   'cubic',   'C', 'c', 2}
        if Inarrears
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminEndDate,'c');
        else
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminBgnDate,'c');
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                         %
% Computation of Swap's fixed rate during Tenor           %
%                                                         %
% FwdIMM                [(Tenor*4) by 1]                  %
% ReqminBgnDate         [(Tenor*4) by 1]                  %
% ReqminEndDate         [(Tenor*4) by 1]                  %
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Translate IMMdata to forward rate in decimal
% e.g 97 is 3% 3-month forward rate.
PeriodRates = (100-FwdIMM)/100;

% Exact ACT/360 based number of years for each
% period between observation dates
PeriodLength = yearfrac(ReqminBgnDate,ReqminEndDate,2);

%%%%%%%%%% FWD vs. FUTURES convexity adjustment %%%%%%%%%
%                                                       %
% Caution: All period rates is of continuous            %
% compounding                                           %
% here before adjustment is made. The PeriodRate of     %
% Eurodollar data is Simple compounding based on        %
% ACT/360.                                              %
% (Also, the period of that Simple compounding is one   %
% quarter because forward rate is valid for one quarter %
%                                                       %
% A conversion is necessary before adjustment is made:  %
%                                                       %
%   r_cont = 4 * log(1 + r_quarter / 4)                 %
%                                                       %
% This convexity adjustment takes into account the      %
% slight difference of forward and futures contract     %
% because data is taken from Eurodollar data (Hull)     %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ConvexAdj
    Bt1_t2  = (1 - exp(-a*PeriodLength) ) / a;

    % t1 is time to beginning of active forward period
    % and is based on actual number of days.
    t1 = yearfrac(StartDate,ReqminEndDate,2);
    B0_t1   = (1 - exp(-a*t1)) / a;

    % t2 is time to end of active forward period

    FwdAdjust = Bt1_t2 ./ (PeriodLength) .* ...
        (Bt1_t2 .* (1 - exp(-2*a*t1)) + 2*a*B0_t1.^2) * ...
        (S^2) / (4*a);

    % The adjustment applies to continuously compounded rate
    % so PeriodRates are first converted to continuous
    % compounding
    PeriodRates = 4 * log(1 + PeriodRates / 4);

    % add the adjustment
    PeriodRates = PeriodRates - FwdAdjust;

    % and finally re-convert to quarterly compounded
    PeriodRates = 4*(exp(PeriodRates/4) - 1);
end

%%%%%%%%%%%%%%%%%% INARREARS ADJUSTMENT %%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
% adjusting PeriodRates if Swap is "inarrears"                %
% Caution: All period rates must be  of quarterly compounding %
% here before adjustment is made, which they already are.     %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Inarrears
    % make adjustment as computed in Hull :

    % time2fwds is time to beginning of active forward period
    % and is based on actual number of days
    time2fwds = yearfrac(StartDate,ReqminEndDate,2);

    FwdAdjust = (PeriodRates .* Sigma.^2 .* ...
        time2fwds .* PeriodLength ) ./ ...
        (1 + PeriodRates .* PeriodLength);

    % Make the adjustment to the period's forward rates
    % due to Inarrears
    PeriodRates = PeriodRates + FwdAdjust;
end

% The amount of interest payable in each period
% Notice how this confirms our ACT/360 basis consistency.
ForwardPayable    = PeriodLength .* PeriodRates;

% Forward Discount Factor on each of the 3-month period
FwdDiscountFactor = (1+ForwardPayable).^-1;

% Discount Factor at the beginning of the first
% 3-month period or exactly, at minBgnDate:
DiscountFactor = cumprod(FwdDiscountFactor);

% Total value of the Floating part per $1 notional
floatpart = sum(ForwardPayable .* DiscountFactor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% END of FLOATING SIDE CALCULATION                       %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% FIXED SIDE CALCULATION                                 %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch FixBasis % bond: does not matter what basis
    case {0; 1; 4; 5; 6}
        CTime = (1:(FixComp*Tenor));
        SFRguess = PeriodRates(end);
        options = optimset('Display','off');
        SFR = fzero(@liborintfun, SFRguess, options, ...
            floatpart, CTime, FixComp);
        MatDate = vecMatDate;

    case 2 % rate: ACT/360
        PeriodLengthFix = PeriodLength;
        fixedpart = PeriodLengthFix .* DiscountFactor;

        % SFR is still under quarterly compounding
        SFR = floatpart / sum(fixedpart);

        % convert the quarterly compounding to FixedCompound
        SFR = ( ( 1+SFR/4)^(4/FixComp) - 1 )*FixComp;

        MatDate = ReqminEndDate(end);

    case {3;7} % rate: ACT/365
        % convert from act/360 to act/365
        PeriodLengthFix = PeriodLength*360/365;
        fixedpart = PeriodLengthFix .* DiscountFactor;

        % SFR is still under quarterly compounding
        SFR = floatpart / sum(fixedpart);

        % convert the quarterly compounding to FixedCompound
        SFR = ( ( 1+SFR/4)^(4/FixComp) - 1 )*FixComp;

        MatDate = ReqminEndDate(end);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Par Fixed-side specification:                             %
% Default is:                                               %
%                                                           %
%   FixedSpec.Coupon   = SFR;                               %
%   FixedSpec.Settle   = ReqminBgnDate(1);                  %
%   FixedSpec.Maturity = MatDate                            %
%   FixedSpec.Period   = 4;                                 %
%   FixedSpec.Basis    = 2;                                 %
%                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FixedSpec.Coupon   = SFR;
FixedSpec.Settle   = datestr(ReqminBgnDate(1));
FixedSpec.Maturity = datestr(MatDate);
FixedSpec.Period   = FixComp;
FixedSpec.Basis    = FixBasis;

% Output Assignment.
varargout = {FixedSpec;ReqminBgnDate;PeriodRates};


function y = liborintfun(x, floatvalue, ctime, n)
% Internal function to solve for SFR where
%
% sum ( SFR / (1 + SFR/FixedComp) .^ T ) = floatvalue
% over the 1st through N = FixedComp * Tenor
y = sum( (x/n) * ((1 + x/n).^-ctime) ) - floatvalue;


% [EOF]
