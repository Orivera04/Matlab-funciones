function FloorPrices = bkfloorlet(varargin)
%BKFLOORLET Prices of floorlet based on Black's model
%  Prices of NFLR number of floorlet for every
%  $100 notional
%
% FloorPrices = bkfloorlet(FloorData, FwdRates, ZeroPrice, ...
%   Settle, StartDate, EndDate, Sigma)
%
% Inputs:
%   FloorData - Matrix of two columns containing
%               Floor rate and its basis in the form of:
%
%               [FloorRate  Basis]
%
%    FwdRates - NFLRx1 vector containing forward-rates, in decimal.
%               FwdRates will accrue at the same Basis as CapRates.
%
%   ZeroPrice - NFLRx1 vector of zero-coupon prices with
%               maturity corresponding to those of each
%               floor in FloorData, per $100 nominal value.
%
%      Settle - Scalar value of valuation date, or settlement
%               date. Optionally, NFLRx1 vector of identical
%               elements can be used.
%
%   StartDate - NFLRx1 vector containing
%               beginning dates of caplets.
%
%     EndDate - NFLRx1 vector of ending date of caplet.
%
%       Sigma - NFLRx1 vector of Volatility of forward rate
%               in decimal, corresponding to each caplet.
%
% Outputs:
% FloorPrices - NFLRx1 vector of caplet prices
%               for every $100 face/notional.
%
% Example:
%  FloorData = [0.08, 1];
%   FwdRates = 0.07;
%  ZeroPrice = 100*exp(-0.065*1.25);
%     Settle = datenum('15-Oct-2002');
%  StartDate = datenum('15-Oct-2003');
%    EndDate = datenum('15-Jan-2004');
%      Sigma = 0.20;
%
% % because floorlet is of $100 notional, we divide $1MM by $100:
%   Notional = 1000000/100;
%
% FloorPrices = Notional*bkfloorlet(FloorData, FwdRates, ...
%   ZeroPrice, Settle, StartDate, EndDate, Sigma)

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.7.2.4 $  $Date: 2004/04/06 01:08:39 $

if nargin < 7
    error('finfixed:bkfloorlet:invalidInputs',...
        'Not enough input arguments. Check "help bkfloorlet" for syntax.');
else

    FloorData     = varargin{1};

    if size(FloorData,2) ~=2
        error('finfixed:floorcaplet:invalidFloordata',...
            'Incorrect size for FloorData input.');
    else
        FRate       = FloorData(:,1);
        Basis       = FloorData(:,2);
    end

    FwdRate     = varargin{2};
    ZeroPrice   = varargin{3};
    SettleOpt   = datenum(varargin{4});

    if any(SettleOpt ~= SettleOpt(1))
        error('finfixed:bkfloorlet:invalidSettleOpt',...
            ['SettleOpt is a Valuation Date,'...
            ' use scalar or identical elements.']);
    end

    FirstReset  = datenum(varargin{5});
    MatOpt      = datenum(varargin{6});
    Sigma       = varargin{7};
end

% Size expansion
[FRate, Basis, FirstReset, FwdRate, ZeroPrice, SettleOpt, MatOpt, Sigma] = ...
    finargsz(1, FRate(:), Basis(:), FirstReset(:), FwdRate(:), ZeroPrice(:), ...
    SettleOpt(:), MatOpt(:), Sigma(:));

if any(SettleOpt > FirstReset)
    error('finfixed:bkfloorlet:invalidSettle',...
        'Floorlet Settle must be prior to BeginDate.');
end

if any(FirstReset >= MatOpt)
    error('finfixed:bkfloorlet:invalidBeginDate',...
        'Floorlet BeginDate must be prior to EndDate.');
end

% compute dt, the time in years between SettleOpt and MatOpt of caplets
dt = yearfrac(FirstReset, MatOpt, Basis);

% Time from Settle to Maturity is on same basis as the volatility
tSettleOpt_FirstReset = yearfrac(SettleOpt, FirstReset, Basis);

% Computing Black's caplet and assign output
warning off;
d1 = (log(FwdRate ./ FRate) + Sigma.^2 .* tSettleOpt_FirstReset/2) ./ ...
    (Sigma .* sqrt(tSettleOpt_FirstReset));

d2 = d1 - Sigma .* sqrt(tSettleOpt_FirstReset);
warning on;

% Notice as mentioned, everything is based on $100 notional
FloorPrices = dt .* ZeroPrice .* ...
    (FRate .* normcdf(-d2) - FwdRate .* normcdf(-d1));
