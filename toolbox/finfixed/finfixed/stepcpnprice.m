function [CleanPrice, AccrInt] = stepcpnprice(varargin)
%STEPCPNPRICE Prices of stepped coupon bonds.
%   Calculates prices and accrued interests on
%   stepped-coupon bonds.
%
% [Price, AccruedInterest] = ...
%   stepcpnprice(Yield, Settle, Maturity, ConvDates, ...
%       CouponRates)
%
% [Price, AccruedInterest] = ...
%   stepcpnprice(Yield, Settle, Maturity, ConvDates, ...
%       CouponRates, Period, Basis, EndMonthRule, Face)
%
% Inputs:
%        Yield - NSTPx1 vector of yield to maturity
%                for the stepped-coupon bonds.
%
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
%                1) Basis = 0 - actual/actual(default)
%                2) Basis = 1 - 30/360
%                3) Basis = 2 - actual/360
%                4) Basis = 3 - actual/365
%
% EndMonthRule - NSTPx1 vector of values specifying whether or
%                not "end of month rule" is in effect for each bond.
%                0 - off
%                1 - on  (default)
%
%         Face - NSTPx1 vector of face value of each bond. Default is $100
%
% Outputs:
%         CleanPrice and AccruedInterest - NBONDS by 1 vectors
%         CleanPrice - Clean price of the bond.
%         AccruedInterest - Accrued interest payable at settlement dates.
%
% (thus the Cash Price is Clean Price + AccruedInterest)
%
% Example:
% % This is an example to price a stepped coupon of known yield,
% % 7.221%, given three scenarios:
% %
% % A. Two Conversion, the first one however,
% %    falls on Settle and thus immediately expires.
% %
% % B. Three Conversions, with conversion dates
% %    exactly on the CouponDates.
% %
% % C. Three Conversions, with one or more conversion dates
% %    not on CouponDates.
% %
% % The last case illustrates that only cash flows after
% % conversion dates are affected.
%
% Yield = 0.07221;
%
% Settle   = datenum('02-Aug-1992');
%
% ConvDate = [datenum('02-Aug-1992'), datenum('15-Jun-2003'), nan;
%             datenum('15-Jun-1997'), datenum('15-Jun-2001'), datenum('15-Jun-2005');
%             datenum('14-Jun-1997'), datenum('14-Jun-2001'), datenum('14-Jun-2005')];
%
% Maturity = datenum('15-Jun-2010');
%
% CouponRates = [0.075 0.08875 0.0925 nan;
%                0.075 0.08875 0.0925 0.1;
%                0.075 0.08875 0.0925 0.1];
% Basis = 1;
% Period = 2;
% EndMonthRule = 1;
% Face = 100;
%
% [CleanPrice, AccruedInterest] = ...
%   stepcpnprice(Yield, Settle, Maturity, ConvDate, CouponRates, ...
%     Period, Basis, EndMonthRule, Face)
%
% References: This function adheres to SIA
%             Fixed Income Securities Formulas for Price, Yield, and
%             Accrued Interest.

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.5.6.4 $   $Date: 2004/04/06 01:09:06 $

if nargin < 5
    error('finfixed:stepcpnprice:invalidInputs',['Not enough input, need Yield, ', ...
        'Settle, Maturity, ConvDate, and CouponRates']);
end

Yield = varargin{1};
Yield = Yield(:);

data(3:4) = varargin(2:3);

if nargin < 6 || isempty(varargin{6})
    data{5} = 2;
else
    data{5} = varargin{6}(:);
end

if nargin < 7 || isempty(varargin{7})
    data{6} = 0;
else
    data{6} = varargin{7}(:);
end

if nargin < 8 || isempty(varargin{8})
    data{7} = 1;
else
    data{7} = varargin{8}(:);
end

if nargin < 9 || isempty(varargin{9})
    data{12} = 100;
else
    data{12} = varargin{9}(:);
end

[CouponRate, Settle, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate,...
    LastCouponDate, StartDate, Face] = instargbond(data{2:end});

% The scalar expansion done inside instargbond may not be
% correct since it doesn't consider "Yield". Make another
% scalar expansion to make sure sizes are appropriate.
[CouponRate, Settle, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate,...
    LastCouponDate, StartDate, Face, Yield] = ...
    finargsz(1, CouponRate, Settle, Maturity, Period, ...
    Basis, EndMonthRule, IssueDate, FirstCouponDate, ...
    LastCouponDate, ones(size(varargin{5},1),1), Face, Yield);

% Now parsing ConvDates and CouponRates
ConvDates   = varargin{4};
CouponRates = varargin{5};

% Checking the size
[convdaterow, convdatecol] = size(ConvDates);
[cpnraterow,  cpnratecol]  = size(CouponRates);

if (convdaterow ~= cpnraterow) || (convdatecol ~= (cpnratecol-1))
    error('finfixed:stepcpnprice:invalidSizeConvDataCpnRate',...
        ['Sizes of ConvDate and CouponRates are not correct', sprintf('\n'),...
        'They both must have the same number of rows, ',...
        'but CouponRate must have one more column.']);
end

if (convdaterow ~= length(Settle))
    error('finfixed:stepcpnprice:invalidConvDataCpnRateMatrix',...
        ['Not enough data in ConvDate and/or CouponRates matrices', ...
        ' corresponding to the number of Bonds being specified.']);
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

%calculate "sharable" information to cut processing
DSC = cpndaysn(Settle, Maturity, Period, Basis, EndMonthRule);
E   = cpnpersz(Settle, Maturity, Period, Basis, EndMonthRule);
A   = cpndaysp(Settle, Maturity, Period, Basis, EndMonthRule);

CleanPrice = zeros(NBonds,1);
AccrInt = zeros(NBonds,1);
PVRV = zeros(NBonds,1);
PVCoupon = zeros(NBonds,1);

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

    [CFlowAmounts, CFlowDates] = cfamounts(CouponRates(i,1:idxnotnan(i)), ...
        QuasiSettle, QuasiMaturity, Period(i), Basis(i), EndMonthRule(i), ...
        [], [], [], [], Face(i));

    % get the column index of the quasi maturities of Bond(i)
    [principal, idxcol] = max((~isnan(CFlowAmounts) .* CFlowDates),[],2);

    % So, just get the coupons -
    % remove the face-element from "quasi" and "real" maturities
    for j = 1:length(QuasiSettle)
        CFlowAmounts(j,idxcol(j)) = CFlowAmounts(j,idxcol(j)) - Face(i);
    end

    %Exclude accrued interest of the QuasiBond
    CFlowAmounts = CFlowAmounts(:,2:end); CFlowDates = CFlowDates(:,2:end);

    %Change all quasi-nan into zeros
    CFlowAmounts(isnan(CFlowAmounts)) = 0;

    % Generate a discount matrix
    K = 1:size(CFlowAmounts,2);
    K = K(ones(1,size(CFlowAmounts,1)),:);
    Discountlocal = (1 + Yield(i)/Period(i)).^-K;

    CFlowAmounts = CFlowAmounts.*Discountlocal;
    SecondSum = sum(CFlowAmounts, 2);  %[Nc(i) by 1]

    PVCoupon(i) = ((1+Yield(i)/Period(i)).^...
        -(CumCpnSinceSettle - 1 + DSC(i)/E(i))) * SecondSum;
    AccrInt(i) =  100*CouponRates(i,1)*A(i)/Period(i)/E(i);
    PVRV(i) = (1 / (1+Yield(i)/Period(i))^(CumCpnSinceSettle(end) - ...
        1 + DSC(i)/E(i))) * (Face(i)/ (1 + Yield(i)/Period(i))^NumCpn(end));

    CleanPrice(i) = PVCoupon(i) + PVRV(i) - AccrInt(i);
end

%%% Send out outputs %%%
CleanPrice = CleanPrice(:);
AccrInt = AccrInt(:);


% [EOF]
