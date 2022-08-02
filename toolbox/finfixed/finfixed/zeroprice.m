function Price = zeroprice(Yield, Settle, Maturity, Period, Basis, EndMonthRule)
%ZEROPRICE Price of zero-coupon given reference bond yield.
%       The function computes prices of NZERO number of zero-coupon
%       given yields of reference bonds.
%       In other words, if the zero-coupon computed with this yield
%       is used to discount the reference bond, the value of that
%       reference bond will be equal its price.
%
% Price = zeroprice(Yield, Settle, Maturity)
%
% Price = zeroprice(Yield, Settle, Maturity, Period, Basis, ...
%       EndMonthRule)
%
% Inputs:
%         Yield - NZEROx1 vector of reference bond
%                 yield, in decimal.
%
%        Settle - NZEROx1 vector of settlement date.
%
%      Maturity - NZEROx1 vector of maturity date.
%
% Optional Inputs:
% (Optional Inputs will specify characteristic
%  of bond referred in the bond-equivalent yield)
%
%        Period - NZEROx1 vector of number of coupons
%                 in a year.
%                 1 - one coupon per year
%                 2 - semiannual     (default)
%                 3 - three times a year
%                 4 - quarterly
%                 6 - bi-monthly compounding
%                12 - monthly
%
%         Basis - NZEROx1 vector of day-count method,
%                 available values are:
%                 0 - actual/actual(default)
%                 1 - 30/360 (SIA compliant)
%                 2 - actual/360
%                 3 - actual/365
%
%  EndMonthRule - NZEROx1 vector of end-of-month rule.
%                 0 - off
%                 1 - on  (default)
%
%  Outputs:
%         Price - Price of the zero-coupon security
%                 per $100 notional.
%
% Example:
% Settle = datenum('02-03-2003');
% Maturity = datenum('08-15-2009');
% Period = 2;
% Basis = 0;
% Yield = 0.03496;
%
% Price = zeroprice(Yield, Settle, Maturity, Period, Basis)
%
% Note: Zero price will compute zero-coupon price for a
% given bond-equivalent yield of any bond.

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.7.6.4 $   $Date: 2004/04/06 01:09:18 $

if nargin<3
    error('finfixed:zeroprice:invalidInputs',...
        'Not enough input. Need at least Settle, Maturity, and Yield.');
end

if nargin<4 || isempty(Period)
    Period = 2;
else
    if any(Period ~= 1 & Period ~=2 & Period ~= 3 & Period ~=4 ...
            & Period ~= 6 & Period ~= 12)
        error('finfixed:zeroprice:invalidPeriod',...
            'Invalid number of coupon payment.');
    end
end

if nargin<5 || isempty(Basis)
    Basis  = 0;
else
    if any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
        error('finfixed:zeroprice:invalidBasis',...
            'Invalid day count basis.');
    end
end

if nargin<6 || isempty(EndMonthRule)
    EndMonthRule = 1;
else
    if any(EndMonthRule ~=0 & EndMonthRule ~=1)
        error('finfixed:zeroprice:invalidEOM',...
            'Invalid End of Month Rule value; must be 0 or 1.');
    end
end

Settle = datenum(Settle);
Maturity = datenum(Maturity);

[Yield, Settle, Maturity, Period, Basis, EndMonthRule] = ...
    finargsz(1, Yield(:), Settle(:), Maturity(:), Period(:),...
    Basis(:), EndMonthRule(:));

Face = 100*ones(length(Yield),1);

% Find out how many quasi coupon left and choose algorithm based on that
numqcpn = cpncount(Settle, Maturity, Period, Basis, EndMonthRule);
swt = (round(numqcpn) == 1);

% initialize DSR and DSC
DSR = zeros(length(Yield),1);
DSC = DSR;

idx1act  = find(swt==1 & (Basis==0 | Basis==2 | Basis==3));
idx1sia  = find(swt==1 & Basis==1);

idx1 = [idx1act(:);idx1sia(:)];

idx0act  = find(swt==0 & (Basis==0 | Basis==2 | Basis==3));
idx0sia  = find(swt==0 & Basis==1);

idx0 = [idx0act(:);idx0sia(:)];

if ~isempty(idx1)
    if ~isempty(idx1act) % idx1 denotes less than one quasi coupon to maturity
        DSR(idx1act) = daysact(Settle(idx1act) , Maturity(idx1act));
    end

    if ~isempty(idx1sia) % idx1 denotes less than one quasi coupon to maturity
        DSR(idx1sia) = days360(Settle(idx1sia), Maturity(idx1sia));
    end

end

Price(idx1) = prdisc_simple(Settle(idx1), Maturity(idx1), Face(idx1), ...
    Yield(idx1), Period(idx1), Basis(idx1), DSR(idx1), EndMonthRule(idx1));

if ~isempty(idx0)
    DSC(idx0) = cpndaten(Settle(idx0), Maturity(idx0), Period(idx0), ...
        Basis(idx0), EndMonthRule(idx0));

    if ~isempty(idx0act) % idx0 denotes more than one quasi coupon to maturity
        DSC(idx0act) = daysact(Settle(idx0act), DSC(idx0act));
    end

    if ~isempty(idx0sia) % idx0 denotes more than one quasi coupon to maturity
        DSC(idx0sia) = days360(Settle(idx0sia),DSC(idx0sia));
    end

    Price(idx0) = prdisc_pv(Settle(idx0), Maturity(idx0), Face(idx0), Yield(idx0), ...
        Period(idx0), Basis(idx0), numqcpn(idx0), DSC(idx0), EndMonthRule(idx0));
end

Price = Price(:);

%=============================================================================

function p = prdisc_simple(sd,md,rv,yield,period,basis,DSR,EOM)
% prdisc_simple computes zero factor based on yields

idx1 = find(basis==0);
idx2 = find(basis==1);
idx3 = find(basis==3);

E = zeros(length(sd),1);

if ~isempty(idx1)
    E(idx1) = cpnpersz(sd(idx1),md(idx1),period(idx1),basis(idx1),EOM(idx1));
end

if ~isempty(idx2)
    E(idx2) = cpnpersz(sd(idx2),md(idx2),period(idx2),basis(idx2),EOM(idx2));
end

if ~isempty(idx3)
    E(idx3) = cpnpersz(sd(idx3),md(idx3),period(idx3),basis(idx3),EOM(idx3));
end

p = rv ./ (1 + DSR.*yield./E./period);


%=============================================================================

function p = prdisc_pv(sd,md,rv,yield,period,basis,Nq,DSC,EOM)
% prdisc_PV computes zero factor based on yields

idx1 = find(basis==0);
idx2 = find(basis==1);
idx3 = find(basis==3);

E = zeros(length(sd),1);

if ~isempty(idx1)
    E(idx1) = cpnpersz(sd(idx1),md(idx1),period(idx1),basis(idx1),EOM(idx1));
end

if ~isempty(idx2)
    E(idx2) = cpnpersz(sd(idx2),md(idx2),period(idx2),basis(idx2),EOM(idx2));
end

if ~isempty(idx3)
    E(idx3) = cpnpersz(sd(idx3),md(idx3),period(idx3),basis(idx3),EOM(idx3));
end

p = rv ./ (1 + yield./period).^(Nq-1+DSC./E);

%=============================================================================


%% SIA Test Suite for ZEROPRICE

function testzeroprice

clear; clc;

%SHORT TERM ZEROS:
%==============
% Benchmark 30A

Settle = '24-Jun-1993';
Maturity = '1-Nov-1993';
Period = 2;
Basis = 0;
Yield = 0.04;

Price30A = zeroprice(Yield, Settle, Maturity, Period, Basis)  %SIA = 98.606645

% Benchmark 30B

Settle = '24-Jun-1993';
Maturity = '1-Nov-1993';
Period = 2;
Basis = 1;
Yield = 0.04;

Price30B = zeroprice(Yield, Settle, Maturity, Period, Basis) %SIA = 98.608524


%LONG TERM ZEROS:
%============
%Benchmark 32A

Settle = '24-Jun-1993';
Maturity = '15-Jan-2024';
Period = 2;
Basis = 0;
Yield = 0.1;

Price32A = zeroprice(Yield, Settle, Maturity, Period, Basis) %SIA = 5.069841

% Benchmark 32B

Settle = '24-Jun-1993';
Maturity = '15-Jan-2024';
Basis = 1;
Yield = 0.1;
Period = 2;
Price32B = zeroprice(Yield, Settle, Maturity, Period, Basis) % SIA = 5.0696814

%Vector Input Test:
%===============
% Regular
Pricevec = zeroprice(Yield, Settle, Maturity, [2,2], [0 1]) %SIA = [5.069841; 5.0696814]
Pricevec2 = zeroprice(Yield, Settle, Maturity, [0 1], [2,2], [0 1]) %SIA = [5.069841; 5.0696814] - EOM has NO effect

% Test where one "short" the other "long" in vector form
Settle = '24-Jun-1993';
Maturity = ['01-Nov-1993'; '15-Jan-2024'];
Basis = [0; 1];
Period = [2;2];
Yield = [0.04; 0.1];

Pricevec3 = zeroprice(Yield, Settle, Maturity, Period, Basis) %SIA = [98.606645   5.0696814]


%Three Input arguments:
%===============
Price3inp = zeroprice(Yield, Settle, Maturity) %SIA = 5.069681


% [EOF]
