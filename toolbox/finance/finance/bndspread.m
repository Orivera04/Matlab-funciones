function varargout = bndspread(varargin)
% BNDSPREAD : Static spread over spot curve
%
% Spread = bndspread(SpotInfo, Price, Coupon, Settle, Maturity)
%
% Spread = bndspread(SpotInfo, Price, Coupon, Settle, ...
%   Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, ...
%       LastCouponDate)
%
% Required Inputs:
%
% SpotInfo  - [Matrix of two columns]
%             First column is SpotDates, and second is
%             zero-rates corresponding to maturities on
%             the SpotDates, semi-annually compounded.
%
%             (We highly recommend spot-rates spaced as
%             little and evenly apart, perhaps one that
%             is built from 3-months deposit rates.)
%
%             Example:
%              SpotInfo = ...
%                 [datenum('2-Jan-2004') ,  0.03840;
%                  datenum('2-Jan-2005') ,  0.04512;
%                  datenum('2-Jan-2006') ,  0.05086];
%
%          Price  - [SCALAR or VECTOR]
%                   Price for every $100 notional of bonds whose spreads are
%                   to be computed
%                   Example: 105.484
%
%          Coupon - [SCALAR or VECTOR]
%                   Annual Coupon rate of bonds whose spreads are to be
%                   computed
%                   Example: 0.04375
%
%          Settle - [SCALAR or VECTOR of IDENTICAL ELEMENTS]
%                   Settlement date of bonds whose spread are to be
%                   computed.
%                   Example: datenum('26-Nov-2002')
%
%        Maturity - [SCALAR or VECTOR]
%                   Maturity date of bonds whose spread are to be computed
%                   Example: datenum('15-Oct-2006')
%
% Optional Inputs:
%
%          Period - [SCALAR or VECTOR]
%                   Number of payment in a year. Default is 2 (semiannual)
%                   Possible values are 1, 2, 3, 4, 12.
%
%           Basis - [SCALAR or VECTOR]
%                   Basis of bonds whose spread are to be computed.
%
%                   0 - actual/actual(default)
%                   1 - 30/360 (SIA compliant)
%                   2 - actual/360
%                   3 - actual/365
%
%    EndMonthRule - [SCALAR or VECTOR]
%                   Use 1 for on (default) or 0 for off. Will make sure
%                   all payments are in the end of months when one of
%                   coupon is on the last day of a 30-day month.
%
%       IssueDate - [SCALAR or VECTOR]
%                   Also known as Dated date.
%                   Example: datenum('25-Oct-2001')
%
% FirstCouponDate - [SCALAR or VECTOR]
%                   Date when a bond makes its first coupon payment.
%                   When FirstCouponDate and LastCouponDate are both
%                   specified, FirstCouponDate takes precedence in
%                   determining the coupon payment structure.
%                   Example: datenum('15-April-2002')
%
%  LastCouponDate - [SCALAR or VECTOR]
%                   Last coupon date of a bond prior to the
%                   maturity date.
%
% Outputs:
%
%          Spread - [SCALAR or VECTOR]
%                   Static Spread to benchmark, in basis points.
%
% Example:
% % Computing a FNMA 4 3/8 spread over treasury spot-curve
%
% % Building Spot Curve
% RefMaturity = [datenum('02/27/2003');
%                datenum('05/29/2003');
%                datenum('10/31/2004');
%                datenum('11/15/2007');
%                datenum('11/15/2012');
%                datenum('02/15/2031')];
%
% RefCpn = [0;
%           0;
%           2.125;
%           3;
%           4;
%           5.375] / 100;
%
% RefPrices =  [99.6964;
%               99.3572;
%              100.3662;
%               99.4511;
%               99.4299;
%              106.5756];
%
% RefBonds = [RefPrices, RefMaturity, RefCpn];
% Settle   = datenum('26-Nov-2002');
% [ZeroRates, CurveDates] = zbtprice(RefBonds(:,2:end), RefPrices, Settle)
%
% % FNMA 4 3/8 maturing 10/06 at 4.30 pm Tuesday, Nov 26, 2002
% Price    = 105.484;
% Coupon   = 0.04375;
% Maturity = datenum('15-Oct-2006');
%
% % All optional inputs are supposed to be accounted by default,
% % except the accrued interest under 30/360 (SIA), so:
% Period = 2;
% Basis  = 1;
% SpotInfo = [CurveDates, ZeroRates];
%
% % Computing the static spread over treasury curve, taking into account
% % the shape of curve as derived by bootstrapping method embedded within
% % "bndspread"
% SpreadInBP = bndspread(SpotInfo, Price, Coupon, Settle, Maturity, Period, Basis)
%
% plot(CurveDates, ZeroRates*100, 'b', CurveDates, ZeroRates*100+SpreadInBP/100, 'r--')
% legend({'Treasury'; 'FNMA 4 3/8'})
% grid;

% Author: Bob Winata
% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $  $Date: 2004/04/06 01:06:50 $
% $ Revision: 1.0 $ $Date: 2004/04/06 01:06:50 $

% parse inputs:
if nargin < 5
    error('Finance:bndspread:tooFewInputs',...
        'You must enter SpotInfo, Price, Coupon, Settle, and Maturity.');
else
    SpotRateData  = varargin{1};
    spotcol = size(SpotRateData,2);

    if spotcol<2
        error('Finance:bndspread:tooFewColumns',...
            'Need at least 2 columns: SpotDates and SpotRates.')
    else
        CurveDates = datenum(SpotRateData(:,1));
        ZeroRatesSemi = SpotRateData(:,2);
    end

    % admit only sorted and unique set of forward rates
    [CurveDates, m, n] = unique(CurveDates);
    ZeroRatesSemi = ZeroRatesSemi(m);

    % Get other necessary inputs
    Price  = varargin{2};
    CouponRate = varargin{3};
    Settle = datenum(varargin{4});
    Settle = Settle(1);
    Maturity = datenum(varargin{5});

    % check if spotrate data is obsolete
    if min(CurveDates) <= Settle
        error('Finance:bndspread:invalidSettle',...
            'First spot rate data must be on, or after Settle.')
    end

    % appending the spot rate at Settle if not yet done
    % it is going to be equal to the shortest maturity
    % as measured from Settle.
    if min(CurveDates) > Settle
        CurveDates(2:end+1) = CurveDates;
        CurveDates(1) = Settle;
        ZeroRatesSemi(2:end+1) = ZeroRatesSemi;
    end

end

% Optional inputs
if nargin < 6 | isempty(varargin{6})
    Period = 2;
else
    Period = varargin{6}(:);
end

if nargin < 7 | isempty(varargin{7})
    Basis = 0;
else
    Basis = varargin{7}(:);
end

if nargin < 8 | isempty(varargin{8})
    EOMRule = 1;
else
    EOMRule = varargin{8}(:);
end

if nargin < 9 | isempty(varargin{9})
    IssueDate = [];
else
    IssueDate = datenum(varargin{9});
end

if nargin < 10 | isempty(varargin{10})
    FirstCouponDate = [];
else
    FirstCouponDate = datenum(varargin{10});
end

if nargin < 11 | isempty(varargin{11})
    LastCouponDate = [];
else
    LastCouponDate = datenum(varargin{11});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bond computation                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[CFlowAmounts, CFlowDates, CFlowTimes] = ...
    cfamounts(CouponRate, Settle, Maturity, Period, Basis, EOMRule, ...
    IssueDate, FirstCouponDate, LastCouponDate);

% Linearly interpolate the spot curve ZeroRatesSemi
% to values on bonds cash flow dates, still preserving
% semi-annual quotation.
SpotOnCFlowDatesSemi = ...
    interp1(CurveDates, ZeroRatesSemi, CFlowDates','linear')';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We are solving the following:                                        %
%                                                                      %
% " QuotedPrice - CFlowAmounts .* (1 + (Spot+Spread)/2).^-TFSemi = 0 " %
%                                                                      %
% keeping in mind that accrued interest is negative within             %
% CFlowAmounts and thus the validity it being subtracted               %
% from QuotedPrice (or some say "clean" price).                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subtract price so Spread will make NPV = 0
CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price;
NumCF = size(CFlowAmounts, 2);

% Spread is initially guessed to be close to the coupon at each period
x0 = CouponRate ./  Period;

% setting an option to suppress optimization results
options1 = optimset('Display','off');

% FSOLVE will iteratively solve for the value of OAS (X) that will make
% the price of the bond equal to given market clean price
X = fsolve(@spreadintfun, x0, options1, CFlowAmounts, ...
    CFlowTimes, NumCF, SpotOnCFlowDatesSemi, Period);

% basis point is 10,000 times of Spread in decimal
varargout{1} = 10000*X;

function y = spreadintfun(x, CF, TF, b, spotrates, Period)
% Calculate and construct a discount matrix applicable to
% each and every predicted cash flows of the MBS
Disc = 1 ./ ...
    ( 1 + (spotrates + x(:, ones(b,1)))/2 );

% Calculate discounted cash flows
dcf = CF .* (Disc.^TF);

% Prior to summing, change the Nan elements to zero
dcf(isnan(dcf))= 0;

% sum horizontally to obtain price
y = sum(dcf,2);


% [EOF]
