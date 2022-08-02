function varargout = stepcpncfamounts(varargin)
%STEPCPNCFAMOUNTS Cash flow and time mapping for stepped-coupon.
%   Cash flow amounts, dates, and times of NSTP number of
%   stepped-coupon bonds. Each stepped coupon can specify
%   different NCONV number of conversion schedule.
%
% [CFlows, CDates, CTimes] = stepcpncfamounts(Settle, Maturity, ...
%   ConvDates, CouponRates)
%
% [CFlows, CDates, CTimes] = stepcpncfamounts(Settle, Maturity, ...
%   ConvDate, CouponRates, Period, Basis, EndMonthRule, Face)
%
%  Inputs:
%       Settle - NSTPx1 vector of settlement dates
%                of the bonds in serial dates.
%
%     Maturity - NSTPx1 maturity dates for each bond
%                in the portfolio.
%
%    ConvDates - Matrix(*) of NSTP x max(NCONV) containing
%                conversion dates AFTER Settle.
%
%  CouponRates - Matrix(*) of NSTP x max(NCONV+1) containing
%                coupon rates for each bond in the portfolio
%                in decimal form. First column of this matrix
%                contains rates applicable between Settle and
%                dates in the first column of ConvDates.
%
%   (*)ConvDates MUST HAVE 1 (one) less column than CouponRates.
%      A diagram to illustrate the above description:
%
%   Settle-----------ConvDate1------------ConvDate2-----------Maturity
%           CpnRate1            CpnRate2             CpnRate3
%
%   If first column of ConvDates, ConvDate1, equals Settle,
%   then CpnRate1 will have NO effect.
%   At the event that there is bond with different number of
%   conversion dates, the shorter schedule will need to be
%   padded with NaN.
%
%  Optional Inputs:
%       Period - NSTPx1 vector of coupon payments frequency per year in
%                integer form;
%                 0 - zero coupon payments
%                 1 - annual coupon payments
%                 2 - semi-annual coupon payments  (default)
%                 3 - three coupon payments per year
%                 4 - quarterly coupon payments
%                 6 - semi-monthly coupon payments
%                12 - monthly coupon payments
%
%        Basis - NSTPx1 vector of values specifying the basis
%                for each bond. Possible values are:
%                0 - actual/actual(default)
%                1 - 30/360
%                2 - actual/360
%                3 - actual/365
%
% EndMonthRule - NSTPx1 vector of values specifying whether or
%                not "end of month rule" is in effect for each bond.
%                0 - off
%                1 - on (default)
%
%         Face - NSTPx1 vector of face value of each bond. Default is $100
%
%  Outputs:
%       CFlows - Cash flow amounts. First entry in each row vector
%                is the (negative) accrued interest due at settlement.
%                If no accrued interest is due, the first column is zero.
%
%       CDates - Cash flow dates in serial date number form.  At least
%                two columns are always present: one for settlement and
%                one for maturity.
%
%       CTimes - Time factor for SIA semi-annual price/yield conversion:
%                DiscountFactor = (1 + Yield/2).^(-TFactor).
%                Time factors are in units of semi-annual coupon periods.
%
% Example:
% This is an example to generate a stepped cash flows
% for three different bonds, all paying semiannually.
% Their life-span is about 18-19 years each.
%
% A. Two Conversion, the first one however,
%    falls on Settle and immediately expires.
%
% B. Three Conversions, with conversion dates
%    exactly on the CouponDates.
%
% C. Three Conversions, with one or more conversion dates
%    not on CouponDates. It has the longest maturity.
%
% The last case illustrates that only cash flows after
% conversion dates are affected.
%
% Settle   = datenum('02-Aug-1992');
%
% ConvDate = [datenum('02-Aug-1992'), datenum('15-Jun-2003'), nan;
%             datenum('15-Jun-1997'), datenum('15-Jun-2001'), datenum('15-Jun-2005');
%             datenum('14-Jun-1997'), datenum('14-Jun-2001'), datenum('14-Jun-2005')];
%
% Maturity = [datenum('15-Jun-2010');datenum('15-Jun-2010');datenum('15-Jun-2011')];
%
% CouponRates = [0.075 0.08875 0.0925 nan;
%                0.075 0.08875 0.0925 0.1;
%                0.025 0.05    0.0750 0.1];
% Basis = 1;
% Period = 2;
% EndMonthRule = 1;
% Face = 100;
%
% % Calling stepcpncfamounts to compute cash flows and timings
% [CFlows, CDates, CTimes] = stepcpncfamounts(Settle, Maturity, ConvDate, CouponRates)
%
% % Visualizing the third bonds (Coupon schedule: 2.5 - 5 - 7.5 - 10)
% cfplot(CDates(3,:),CFlows(3,:));
% xlabel('Dates in Serial Number')
% ylabel('Relative amounts of CashFlows')
% title('CashFlow diagram of a 2.5 - 5 - 7.5 - 10 stepped coupon bond')

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.6.4 $  $Date: 2004/04/06 01:09:05 $

if nargin < 4
    error('finfixed:stepcpncfamounts:invalidInputs',...
        ['Not enough input, need', ...
        'Settle, Maturity, ConvDate, and CouponRates.']);
end

data(3:4) = varargin(1:2);

if nargin < 5 || isempty(varargin{5})
    data{5} = 2;
else
    data{5} = varargin{5}(:);
end

if nargin < 6 || isempty(varargin{6})
    data{6} = 0;
else
    data{6} = varargin{6}(:);
end

if nargin < 7 || isempty(varargin{7})
    data{7} = 1;
else
    data{7} = varargin{7}(:);
end

if nargin < 8 || isempty(varargin{8})
    data{12} = 100;
else
    data{12} = varargin{8}(:);
end

[CouponRate, Settle, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate,...
    LastCouponDate, StartDate, Face] = instargbond(data{2:end});

% Now parsing ConvDates and CouponRates
ConvDates   = varargin{3};
CouponRates = varargin{4};

% Checking the size
[convdaterow, convdatecol] = size(ConvDates);
[cpnraterow,  cpnratecol]  = size(CouponRates);

[CouponRate, Settle, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate,...
    LastCouponDate, StartDate, Face, dummy] = ...
    finargsz(1,CouponRate, Settle, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate,...
    LastCouponDate, StartDate, Face, ones(convdaterow,1));

if (convdaterow ~= cpnraterow) || (convdatecol ~= (cpnratecol-1))
    error('finfixed:stepcpncfamounts:invalidSizeConvDataCpnRate',...
        ['Sizes of ConvDate and CouponRates are not correct', sprintf('\n'),...
        'They both must have the same number of rows, ',...
        'but CouponRate must have one more column'])
end

if (convdaterow ~= length(Settle))
    error('finfixed:stepcpncfamounts:invalidConvDataCpnRateMatrix',...
        ['Not enough data in ConvDate and/or CouponRates matrices', ...
        ' corresponding to the number of Bonds being specified'])
end

% Use any number to parse inputs other than ConvDates and CouponRates
Anynumber = 0.1;
[AA, checkcouponmatrix] = cfamounts(Anynumber,Settle, Maturity, Period, ...
    Basis, EndMonthRule, [], [], [], [], Face);

% If any the first ConvDates falls on Settle:
% eliminate the first ConvDates by shifting to the left by one element
idxConvOnSettle = find(ConvDates(:,1) == Settle);

tempCpn  = [CouponRates(idxConvOnSettle,2:end), nan*zeros(length(idxConvOnSettle),1)];
tempConv = [ConvDates(idxConvOnSettle,2:end), nan*zeros(length(idxConvOnSettle),1)];

CouponRates(idxConvOnSettle,:) =  tempCpn;
ConvDates(idxConvOnSettle,:) = tempConv;

% if size is OK, Pad the first column of ConvDates with Settle
ConvDates(:,2:end+1) = ConvDates(:,1:end);
ConvDates(:,1) = Settle;

% now find out column index of each row where the last coupon
% switch occurs for each bond
notnanmap = ~isnan(CouponRates).*ConvDates;

% the maximum is the latest valid dates times logical ones of
% the non-nans
[maxnotnanmap, idxnotnan] = max(notnanmap,[],2);

NBonds = length(Settle);

AccrInt = zeros(NBonds,1);
cffinal = zeros(NBonds,1);

%%%%%%%%%%%% Computation %%%%%%%%%%%%%%%%%%%%%%%

for i = 1:NBonds

    % Now this is the tough part, looking for QuasiMaturity that are
    % all immediately after ConversionDates.
    QuasiMaturity = [];

    for j = 2:idxnotnan(i)
        dtc = checkcouponmatrix(i,:)-ConvDates(i,j);
        QuasiMaturity(j-1) = min(checkcouponmatrix(i,min(find(dtc>=0))));
    end

    QuasiMaturity(end+1) = Maturity(i);
    QuasiSettle = [ConvDates(i,1), QuasiMaturity(1:end-1)];  %row vector

    %always Column vector - turn to row first
    NumCpn = (cpncount(QuasiSettle, QuasiMaturity))';

    %remove the last element and add a zero for the first element
    CumCpnSinceSettle = cumsum(NumCpn); % [1 by Nc(i)]

    CumCpnSinceSettle(2:end) = CumCpnSinceSettle(1:end-1);
    CumCpnSinceSettle(1) = 0;

    [CFlowAmounts, CFlowDates, CFlowTimes] = ...
        cfamounts(CouponRates(i,1:idxnotnan(i)), ...
        QuasiSettle, QuasiMaturity, Period(i), Basis(i), ...
        EndMonthRule(i), [], [], [], [], Face(i));

    % get the column index of the quasi maturities of Bond(i)
    [principal, idxcol] = max((~isnan(CFlowAmounts) .* CFlowDates),[],2);

    % So, just get the coupons -
    % remove the face-element from "quasi" and "real" maturities

    numQS = length(QuasiSettle);

    for j = 1:numQS
        CFlowAmounts(j,idxcol(j)) = CFlowAmounts(j,idxcol(j)) - Face(i);
    end

    % return the real notional
    CFlowAmounts(j,idxcol(j)) = CFlowAmounts(j,idxcol(j)) + Face(i);
    cffinal(i) = CFlowAmounts(j,idxcol(j));

    % store the real accrued interest
    AccrInt(i)   = CFlowAmounts(1,1);

    CFlowAmounts = CFlowAmounts(:,2:end);
    CFlowDates   = CFlowDates(:,2:end);
    CFlowTimes   = CFlowTimes(:,2:end);

    % adjusting the times of quasi bonds with
    % cumulative time since Settlement date.
    maxTimes = max(CFlowTimes,[],2);
    maxTimes = cumsum([0;maxTimes(1:end-1)]);
    maxTimes = maxTimes(:,ones(size(CFlowTimes,2),1));
    CFlowTimes = CFlowTimes + maxTimes;

    nlms = numel(CFlowAmounts);

    CFlows(i,1:nlms) = reshape(CFlowAmounts',1,nlms);
    CDates(i,1:nlms) = reshape(CFlowDates',  1,nlms);
    CTimes(i,1:nlms) = reshape(CFlowTimes',  1,nlms);

    relevantidx = find(~isnan(CFlows(i,:)));
    maxcol(i) = numel(relevantidx);

    CFlows(i,1:maxcol(i)) = CFlows(i,relevantidx);
    CDates(i,1:maxcol(i)) = CDates(i,relevantidx);
    CTimes(i,1:maxcol(i)) = CTimes(i,relevantidx);
end

numcolfin = size(CFlows,2);

% numcolfin - maxcol is at least zero
% that means the reminder is irrelevant
for i = 1:NBonds
    if maxcol(i) < numcolfin
        CFlows(i,(maxcol(i)+1):end) = nan;
        CDates(i,(maxcol(i)+1):end) = nan;
        CTimes(i,(maxcol(i)+1):end) = nan;
    end

    % find the last payment, which consists of principal and interest
    idxfinal(i) = find(CFlows(i,:)==cffinal(i));
    if idxfinal(i) < numcolfin
        CFlows(i,idxfinal(i)+1:end) = nan;
        CDates(i,idxfinal(i)+1:end) = nan;
        CTimes(i,idxfinal(i)+1:end) = nan;
    end
end

CFlows = CFlows(:,1:max(idxfinal(i)));
CDates = CDates(:,1:max(idxfinal(i)));
CTimes = CTimes(:,1:max(idxfinal(i)));

% the last remaining case when you get trailing
% zeros at the last batch of conversion
CFlows = [AccrInt, CFlows];
CDates = [Settle,  CDates];
CTimes = [zeros(NBonds,1), CTimes];

% assigning outputs
varargout = {CFlows;CDates;CTimes};


% [EOF]
