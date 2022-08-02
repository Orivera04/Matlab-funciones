function CapPrices = bkcaplet(varargin)
%BKCAPLET Prices of caplet based on Black's model.
%  Prices of NCAP number of caplet for every 
%  $100 notional
%
% CapPrices = bkcaplet(Capdata, FwdRates, ZeroPrice, ...
%   Settle, BeginDate, EndDate, Sigma)
%
% Inputs:
%     Capdata - Matrix of two columns for 
%               Cap rate and its basis in the form of:
%               
%               [CapRates  Basis]
%
%    FwdRates - NCAPx1 vector containing forward-rates, in decimal.
%               FwdRates will accrue at the same Basis as CapRates.
%
%   ZeroPrice - NCAPx1 vector of zero-coupon prices with 
%               maturity corresponding 
%               to those of of each cap in CapData, per $100
%               nominal value.
%
%      Settle - Scalar value of valuation date, or settlement
%               date. Optionally, NCAPx1 vector of identical 
%               elements can be used.
%
%   StartDate - NCAPx1 vector containing
%               beginning dates of caplets.
%
%     EndDate - NCAPx1 vector of ending date of caplet.
%
%       Sigma - NCAPx1 vector of Volatility of forward rate 
%               in decimal, corresponding to each caplet.
%
% Outputs:
%   CapPrices - NCAPx1 vector of caplet prices 
%               for every $100 face/notional.
%
% Example:
%  
% Given a notional of $1MM, compute the value of a caplet on Oct 15, 2002
% that will start on Oct 15, 2003 and end on Jan 15, 2004:
%  
%    CapData = [0.08 , 1];
%   FwdRates = 0.07;
%  ZeroPrice = 100*exp(-0.065*1.25);
%     Settle = datenum('15-Oct-2002');
%  StartDate = datenum('15-Oct-2003');
%    EndDate = datenum('15-Jan-2004');
%      Sigma = 0.20;
% 
% % because caplet is of $100 notional, we divide $1MM by $100:
% Notional   = 1000000/100; 
%
% CapPrices  = Notional*bkcaplet(CapData, FwdRates, ZeroPrice, ...
%     Settle, StartDate, EndDate, Sigma)

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.7.2.4 $  $Date: 2004/04/06 01:08:38 $

if nargin < 7
    error('finfixed:bkcaplet:invalidInputs',...
        'Not enough input arguments. Check "help bkcaplet" for syntax.');
else
    CapData     = varargin{1};

    if size(CapData,2) ~=2
        error('finfixed:bkcaplet:invalidCapdata',...
            'Incorrect size for Capdata input.');
    else
        CRate   = CapData(:,1);
        Basis   = CapData(:,2);
    end

    FwdRate     = varargin{2};
    ZeroPrice   = varargin{3};
    SettleOpt   = datenum(varargin{4});

    if any(SettleOpt ~= SettleOpt(1))
        error('finfixed:bkcaplet:invalidSettleOpt',...
            ['SettleOpt is a Valuation Date,'...
            ' use scalar or identical elements.']);
    end
    
    FirstReset  = datenum(varargin{5});
    MatOpt      = datenum(varargin{6});
    Sigma       = varargin{7};
end

% Size expansion
[CRate, Basis, FirstReset, FwdRate, ZeroPrice, SettleOpt, MatOpt, Sigma] = ...
    finargsz(1, CRate(:), Basis(:), FirstReset(:), FwdRate(:), ZeroPrice(:), ...
    SettleOpt(:), MatOpt(:), Sigma(:));

if any(SettleOpt > FirstReset)
    error('finfixed:bkcaplet:invalidSettle',...
        'Caplet Settle must be prior to BeginDate');
end

if any(FirstReset >= MatOpt)
    error('finfixed:bkcaplet:invalidBeginDate',...
        'Caplet BeginDate must be prior to EndDate');
end

% icompute dt, the time in years between SettleOpt and MatOpt of caplets
dt = yearfrac( FirstReset, MatOpt, Basis );

% Time from Settle to Maturity is on same basis as the volatility
tSettleOpt_FirstReset = yearfrac( SettleOpt, FirstReset, Basis );

% Computing Black's caplet and assign output
warning off;
d1 = (log(FwdRate ./ CRate) + Sigma.^2 .* tSettleOpt_FirstReset/2) ./ ...
    (Sigma .* sqrt(tSettleOpt_FirstReset));

d2 = d1 - Sigma .* sqrt(tSettleOpt_FirstReset);
warning on;

CapPrices = dt .* ZeroPrice .* ...
    (FwdRate .* normcdf(d1) - CRate .* normcdf(d2));