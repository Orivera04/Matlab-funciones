function Price = liborprice(varargin)
%LIBORPRICE Fair price per $100 notional of a swap given the swap rate.
%   The price computed is the present value difference between the fixed-rate
%   side and the floating-rate side. A positive value indicates a relative
%   increase in the fixed-side value when compared to floating-side.
%
%   Price = liborprice(ThreeMonthRates, Settle, Tenor, SwapRate)
%
%   Price = liborprice(ThreeMonthRates, Settle, Tenor, SwapRate, StartDate, ...
%       Interpolation, ConvexAdj, RateParam, Inarrears, Sigma, ...
%       FixedCompound, FixedBasis)
%
%   Optional Inputs: StartDate, Interpolation, ConvexAdj, RateParam, Inarrears, 
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
%          SwapRate - [Scalar] value to denote swap rate in decimal.
%
%   Optional Input:
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
%   Price - Value difference between the floating and fixed-rate side of the 
%   swap per $100 notional.
%
%   Example:
%   % This example shows that a swap paying par swap rate has zero value:
%
%   [ThreeMonthRates, textdata] = xlsread('EDdata.xls');
%   Settle                      = datenum('15-Oct-2002');
%   Tenor                       = 2;
%
%   FixedSpec = liborfloat2fixed(ThreeMonthRates, Settle, Tenor);
%
%   % Now pricing the par-swap:
%
%   Price = liborprice(ThreeMonthRates, Settle, Tenor, FixedSpec.Coupon)
% 
%   Price =
%     3.4694e-015

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.9.6.5 $   $Date: 2004/04/06 01:08:48 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Parsing User Input      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <3
    error('finfixed:liborprice:invalidInputs',...
        'Need at least EuroDollarData, Settle, and Tenor.');
else
    EuroData = varargin{1};
    Months   = EuroData(:,1);
    Years    = EuroData(:,2);
    IMMdataF = EuroData(:,3);

    if any(IMMdataF > 100)
        error('finfixed:liborprice:negativeFwdRate',...
            ['Negative forward rate detected.', sprintf('\n') ...
            'Please check your input.']);
    end

    Settle = datenum(varargin{2});
    Tenor = ceil(varargin{3});
    SwapRate = varargin{4};
end

if nargin<5 || isempty(varargin{5})
    StartDate = Settle;
else
    StartDate = datenum(varargin{5});

    % value check on StartDate
    if StartDate > Settle
        error('finfixed:liborprice:invalidStartDate',...
            'StartDate must be less than or equal to Settle.');
    end

end

if nargin<6 || isempty(varargin{6})
    Interpolation = 1;
else
    Interpolation = floor(varargin{6});

    if any(Interpolation~=0 & Interpolation~=1 & Interpolation~=2)
        error('finfixed:liborprice:invalidInterpolation',...
            'Invalid Interpolation method.');
    end
end

if nargin<7 || isempty(varargin{7})
    ConvexAdj = 0;
else
    ConvexAdj = floor(varargin{7});
    if any(ConvexAdj~=0 & ConvexAdj~=1)
        error('finfixed:liborprice:invalidConvexAdj',...
            'Invalid ConvexAdj method.');
    end
end

if nargin<8 || isempty(varargin{8})

    a = 0.05;
    S = 0.015;

else
    RateParam = varargin{8};
    if numel(RateParam) - 2
        error('finfixed:liborprice:invalidRateParam',...
            'RateParam must be a row or column vector [a S].');
    end

    a = RateParam(1);
    S = RateParam(2);
end

if nargin<9 || isempty(varargin{9})
    Inarrears = 0;
else
    Inarrears = varargin{9};
    if any(Inarrears~=0 & Inarrears~=1)
        error('finfixed:liborprice:invalidInarrears',...
            'Invalid Inarrears method.');
    end
end

if nargin<10 || isempty(varargin{10})
    Sigma = 0;
else
    Sigma = varargin{10};
end

if nargin<11 || isempty(varargin{11})
    FixComp = 4;
else
    FixComp = floor(varargin{11});

    % Check for allowed compounding
    if any(FixComp ~= 1 & FixComp ~= 2 & FixComp ~= 4 & FixComp ~=12)
        error('finfixed:liborprice:invalidFixedCompound',...
            'Invalid FixedCompound specified.');
    end
end

if nargin<12 || isempty(varargin{12})
    FixBasis = 1;
else
    FixBasis = floor(varargin{12});

    % check for allowed Basis
    if (FixBasis<0 || FixBasis>7)
        error('finfixed:liborprice:invalidFixedBasis',...
            'Invalid FixedBasis specified.');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% FLOATING SIDE CALCULATION                              %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct "raw" data based on user's input
[BgnFwdDatesF EndFwdDatesF] = ...
    thirdwednesday(Months, Years);

%%%%%%%%%%%%%%% DATA INTEGRITY ROUTINE %%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%  1) is Forward data sufficient given Settle and StartDate  %
%  2) is Forward data sufficient given Tenor                 %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% This will be necessary yo determine the immediate
% third wednesdays for Settle and Start-Dates:
% What we do know however, is that they are either
% THIS month or the NEXT, can't say for sure yet:
datevecSettle = datevec(Settle);
datevecSettleA = datevecSettle;
datevecStart = datevec(StartDate);
datevecStartA = datevecStart;

datevecSettleA(2) = datevecSettleA(2)+1;
datevecSettleA = datenum(datevecSettleA);
datevecSettleA = datevec(datevecSettleA);

datevecStartA(2) = datevecStartA(2)+1;
datevecStartA = datenum(datevecStartA);
datevecStartA = datevec(datevecStartA);

% Relevant forward data is that of AFTER Settlement
relevant  = find(BgnFwdDatesF>=Settle);

% minimum value of the relevant's index
minidx = min(relevant);

% assume that Settle
minidxtag = 0;

if minidx >1 % exclusively after Settle
    % thus it is Guaranteed there is at least one
    % previous element
    minidxtag = 1;
    priorfwddate = BgnFwdDatesF(minidx-1);
    priorfwdrate = IMMdataF(minidx-1);
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

% In pricing it is also necessary to discount to the StartDate
[minBgnDateF minEndDateF]  = ...
    thirdwednesday([datevecStart(2); datevecStartA(2)], ...
    [datevecStart(1); datevecStartA(1)]);

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

% same thing with StartDate:
if StartDate > minBgnDateF(1)
    minBgnDateF = minBgnDateF(2);
    minEndDateF = minEndDateF(2);
else
    minBgnDateF = minBgnDateF(1);
    minEndDateF = minEndDateF(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input tuning for Settle                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% and see which one is after the settlement
if BgnFwdDates(1) == minBgnDate
    % do nothing, Settle is covered by Forward Data
else %warns and assume Settle is equal to nearest Forward value
    warning(['It appears that Forward Rate information is incomplete.', ...
        sprintf('\n') ...
        'Appending data for ', datestr(minBgnDate), sprintf('\n'), ...
        '- that is, the start of first forward period after Settle.']);

    BgnFwdDates(2:end+1) = BgnFwdDates;
    BgnFwdDates(1) = minBgnDate;

    EndFwdDates(2:end+1) = EndFwdDates;
    EndFwdDates(1) = minEndDate;

    IMMdata(2:end+1)     = IMMdata;

    % minidxtag equals one says that all "relevant" forward data
    % occurs after Settle:
    if minidxtag
        % first look if data is contained within the full-array information
        % so that interpolation would not be needed:
        idx = find(BgnFwdDatesF == BgnFwdDates(1));

        if ~isempty(idx)
            IMMdata(1) = IMMdataF(idx);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input tuning for StartDate                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if BgnFwdDatesF(1) == minBgnDateF
    % do nothing, StartDate is covered by Forward Data
else %warns and assume StartDate data is equal to nearest Forward value
    warning(['It appears that Forward Rate information is incomplete.', ...
        sprintf('\n') ...
        'Appending data for ', datestr(minBgnDateF), sprintf('\n'), ...
        '- that is, the start of first forward period after StartDate.']);

    BgnFwdDatesF(2:end+1) = BgnFwdDatesF;
    BgnFwdDatesF(1) = minBgnDateF;

    EndFwdDatesF(2:end+1) = EndFwdDatesF;
    EndFwdDatesF(1) = minEndDateF;

    IMMdataF(2:end+1)     = IMMdataF;
end

% Compute three-month periods between StartDate and Settle,
% if they are not equal (StartDate ~= Settle) and consequently
% Discount Factor thenceforth to Settle:
ReqEndStart = datevec(minBgnDate);
ReqEndMnt = ReqEndStart(2);
ReqEndYrs = ReqEndStart(1);

ReqBgnStart = datevec(minBgnDateF);
ReqBgnMnt = ReqBgnStart(2);
ReqBgnYrs = ReqBgnStart(1);

% computing pseudo-months of ReqEndStart:
pseudomnt = 12 * daysact(ReqBgnYrs,ReqEndYrs) + ReqEndMnt;
pseudomnt = (ReqBgnMnt:3:pseudomnt)';

ReqBgnStart = ReqBgnStart(ones(1,numel(pseudomnt)), :);
ReqBgnStart(:,2) = pseudomnt;
ReqBgnStart(:,1) = ReqBgnYrs;
ReqBgnStart = datenum(ReqBgnStart);
ReqBgnStart = datevec(ReqBgnStart);

[ReqBgnStart, ReqEndStart] = ...
    thirdwednesday(ReqBgnStart(:,2), ReqBgnStart(:,1));

switch Interpolation
    case 0
        IMMStartSet = ...
            interp1(BgnFwdDatesF, IMMdataF, ReqBgnStart, 'nearest');
    case 1
        IMMStartSet = ...
            interp1(BgnFwdDatesF, IMMdataF, ReqBgnStart, 'linear');
    case 2
        IMMStartSet = ...
            interp1(BgnFwdDatesF, IMMdataF, ReqBgnStart, 'cubic');
end

ReqEndStart(end) = minBgnDate;
PeriodStart = yearfrac(ReqBgnStart, ReqEndStart, 2 );

ConvexAdjStartTag = 1;

if PeriodStart(end) == 0
    if length(PeriodStart) > 1
        PeriodStart = PeriodStart(1:end-1);
        ReqBgnStart = ReqBgnStart(1:end-1);
        ReqEndStart = ReqEndStart(1:end-1);
        IMMStartSet = IMMStartSet(1:end-1);
    else % does not need any convexity adjustment
        % because PeriodStart(end) = minBgnDate(1)
        % StartDate = Settle.
        ConvexAdjStartTag = 0;
    end
end

FwdStartSet = (100 - IMMStartSet)/100;

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
    warning(['It appears that Forward Rate information is incomplete.', ...
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
vecminEndDate = datevec(minEndDate);

% Tony's trick to expand the single row into a matrix
% of identical rows followed by adding multiple of threes
% into the months.
vecminBgnDate = vecminBgnDate(ones(1,Tenor*4),:);
vecminBgnDate(:,2) = vecminBgnDate(:,2) + 3*(0:(Tenor*4 - 1))';
vecminBgnDate = datenum(vecminBgnDate);

vecminEndDate = vecminEndDate(ones(1,Tenor*4),:);
vecminEndDate(:,2) = vecminEndDate(:,2) + 3*(0:(Tenor*4 - 1))';
vecminEndDate = datenum(vecminEndDate);

vecminBgnDate = datevec(vecminBgnDate);
vecminBgnMnt = vecminBgnDate(:,2);
vecminBgnYrs = vecminBgnDate(:,1);

[ReqminBgnDate, ReqminEndDate] = ...
    thirdwednesday(vecminBgnMnt, vecminBgnYrs);

vecminBgnDate = datenum(vecminBgnDate);

switch Interpolation
    case 0
        if Inarrears
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminEndDate,'n');
        else
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminBgnDate,'n');
        end
    case 1
        if Inarrears
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminEndDate,'l');
        else
            FwdIMM = interp1(BgnFwdDates, IMMdata, ReqminBgnDate,'l');
        end
    case 2
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Adjustment for data between Settle and Maturity
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Adjustment for data between Start and Settle:
    if ConvexAdjStartTag
        Bt1_t2  = (1 - exp(-a*PeriodStart) ) / a;

        % t1 is time to beginning of active forward period
        % and is based on actual number of days.
        t1 = (ReqEndStart - StartDate) / 360;
        B0_t1   = (1 - exp(-a*t1)) / a;

        % t2 is time to end of active forward period

        FwdAdjustStart = Bt1_t2 ./ (PeriodStart) .* ...
            (Bt1_t2 .* (1 - exp(-2*a*t1)) + 2*a*B0_t1.^2) * ...
            (S^2) / (4*a);

        % The adjustment applies to continuously compounded rate
        % so PeriodRates are first converted to continuous
        % compounding
        FwdStartSet = 4 * log(1 + FwdStartSet / 4);

        % add the adjustment
        FwdStartSet = FwdStartSet - FwdAdjustStart;

        % and finally re-convert to quarterly compounded
        FwdStartSet = 4*(exp(FwdStartSet/4) - 1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        Parguess = PeriodRates(end);
        options = optimset('Display','off');
        ParRate = fzero(@liborintfun, Parguess, options, ...
            floatpart, CTime, FixComp);
        SettBnd = vecminBgnDate(1);
        MatBnd  = vecminEndDate(end);

        FixedCF = 0.01*cfamounts(SwapRate, SettBnd, ...
            MatBnd, FixComp, FixBasis);
        FixedCF(end) = FixedCF(end) - 1;

        fixedpart = FixedCF(2:end) * (1+ParRate/FixComp).^-CTime';

        Price = 100*(fixedpart-floatpart);

    case 2 % rate: ACT/360

        % convert FixedCompound SwapRate to quarterly
        SwapRate = ( ( 1+SwapRate/FixComp)^(FixComp/4) - 1 )*4;

        fixedpart = sum(SwapRate * PeriodLength .* DiscountFactor);

        Price = 100*(fixedpart-floatpart);

    case {3;7} % rate: ACT/365

        % convert FixedCompound SwapRate to quarterly
        SwapRate = ( ( 1+SwapRate/FixComp)^(FixComp/4) - 1 )*4;
        % convert from act/360 to act/365
        fixedpart = sum(SwapRate * 360/365 * ...
            PeriodLength .* DiscountFactor);

        Price = 100*(fixedpart-floatpart);
end

% Finally make the last adjustment, StartDate to Settle:
FactorStartSettle = ...
    cumprod((1 ./ (1 + FwdStartSet .*PeriodStart)));

Price = FactorStartSettle(end) * Price;

function y = liborintfun(x, floatvalue, ctime, n)
% Internal function to solve for SFR where
%
% sum ( SFR / (1 + SFR/FixedComp) .^ T ) = floatvalue
% over the 1st through N = FixedComp * Tenor
y = sum( (x/n) * ((1 + x/n).^-ctime) ) - floatvalue;


% [EOF]
