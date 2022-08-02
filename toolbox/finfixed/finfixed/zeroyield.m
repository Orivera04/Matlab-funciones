function Yield = zeroyield(Price, Settle, Maturity, Period, Basis, EndMonthRule)
%ZEROYIELD Yield of zero-coupon given its price.
%       Yield of zero coupon will be yields of reference bonds.
%       In other words, if the zero-coupon computed with this
%       yield is used to discount the reference bond,
%       the value of that reference bond will be equal its price.
%
% Yield = zeroyield(Price, Settle, Maturity)
%
% Yield = zeroyield(Price, Settle, Maturity, Basis, EOM)
%
% Inputs:
%         Price - NZEROx1 vector of zero-coupon bond price
%                 per $100 notional
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
% Outputs:
%         Yield - Bond-equivalent yield of the
%                 zero-coupon security
%
% Example:
% Settle = datenum('02-03-2003');
% Maturity = datenum('08-15-2009');
% Period = 2;
% Basis = 0;
% Price = 79.7394;
% 
% Yield = zeroyield(Price, Settle, Maturity, Period, Basis)
%
% Note: Zero price will compute zero-coupon bond-equivalent
%       yield given price of any type of bond.

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $   $Date: 2004/04/06 01:09:19 $

if (nargin<3)
    error('finfixed:zeroyield:invalidInputs',...
        'Need at least Price, Settle, Maturity.');
end

if nargin<4 || isempty(Period)
    Period = 2;
end

if nargin<5 || isempty(Basis)
    Basis = 0;
else
    if any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
        error('finfixed:zeroyield:invalidBasis',...
            'Invalid day count basis.');
    end
end

if nargin<6 || isempty(EndMonthRule)
    EndMonthRule = 1;
else
    if any(EndMonthRule~=0 & EndMonthRule~=1)
        error('finfixed:zeroyield:invalidEOM',...
            'Invalid End of Month Rule value; must be 0 or 1.');
    end
end

Settle = datenum(Settle);
Maturity = datenum(Maturity);

[Price, Settle, Maturity, Period, Basis, EndMonthRule] = ...
    finargsz(1, Price(:), Settle(:), Maturity(:), Period(:), ...
    Basis(:), EndMonthRule(:));

Face = 100*ones(length(Price),1);

% Find out how many quasi coupon left and choose algorithm based on that
numqcpn = cpncount(Settle, Maturity, Period, Basis);
swt = (round(numqcpn) == 1);

idx1act  = find(swt==1 & (Basis==0 | Basis==2 | Basis==3));
idx1sia  = find(swt==1 & Basis==1);

idx1 = [idx1act(:);idx1sia(:)];

idx0act  = find(swt==0 & (Basis==0 | Basis==2 | Basis==3));
idx0sia  = find(swt==0 & Basis==1);

idx0 = [idx0act(:);idx0sia(:)];

% initialize DSR and DSC
DSR = zeros(length(Price),1);
DSC = DSR;

if ~isempty(idx1)
    if ~isempty(idx1act) % idx1 denotes less than one quasi coupon to maturity
        DSR(idx1act) = daysact(Settle(idx1act), Maturity(idx1act));
    end

    if ~isempty(idx1sia) % idx1 denotes less than one quasi coupon to maturity
        DSR(idx1sia) = days360(Settle(idx1sia), Maturity(idx1sia));
    end

    % 1 quasi coupon or less to maturity
    Yield(idx1) = ylddisc_simple(Settle(idx1), Maturity(idx1), ...
        Face(idx1), Price(idx1), Period(idx1), Basis(idx1), ...
        EndMonthRule(idx1), DSR(idx1));
end

if ~isempty(idx0)
    DSC(idx0) = cpndaten(Settle(idx0), Maturity(idx0), Period(idx0), ...
        Basis(idx0), EndMonthRule(idx0));

    if ~isempty(idx0act) % idx0 denotes more than one quasi coupon to maturity
        DSC(idx0act) = daysact(Settle(idx0act),DSC(idx0act));
    end

    if ~isempty(idx0sia) % idx0 denotes more than one quasi coupon to maturity
        DSC(idx0sia) = days360(Settle(idx0sia),DSC(idx0sia));
    end

    Yield(idx0) = ylddisc_pv(Settle(idx0), Maturity(idx0), ...
        Face(idx0), Price(idx0), Period(idx0), Basis(idx0), ...
        numqcpn(idx0),  EndMonthRule(idx0), DSC(idx0));
end

Yield = Yield(:);

%=============================================================================

function yield = ylddisc_simple(sd,md,rv,price,period,basis,EOM,DSR)

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

yield = (rv./price - 1) .* (period.*E./DSR);

%=============================================================================

%=============================================================================

function yield = ylddisc_pv(sd,md,rv,price,period,basis,Nq,EOM,DSC)

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

yield = ((rv./price).^(1./(Nq-1+DSC./E)) - 1) .* period;
%=============================================================================


%% SIA Test Suite for ZEROYIELD

function testzeroyield

clear; clc;

%SHORT TERM ZEROS:
%==============
% Benchmark 31A

Settle = '24-Jun-1993';
Maturity = '1-Nov-1993';
Period = 2;
Basis = 0;
Price = 95;

Yield31A = zeroyield(Price, Settle, Maturity, Period, Basis)  %SIA = 0.148988

% Benchmark 31B

Settle = '24-Jun-1993';
Maturity = '1-Nov-1993';
Period = 2;
Basis = 1;
Price = 95;

Yield31B = zeroyield(Price, Settle, Maturity, Period, Basis) %SIA = 0.1491919


%LONG TERM ZEROS:
%============
% Benchmark 33A

Settle = '24-Jun-1993';
Maturity = '15-Jan-2024';
Period = 2;
Basis = 0;
Price = 9;

Yield33A = zeroyield(Price, Settle, Maturity, Period, Basis) %SIA = 0.0803721

% Benchmark 33B

Settle = '24-Jun-1993';
Maturity = '15-Jan-2024';
Period = 2;
Basis = 1;
Price = 9;

Yield33B = zeroyield(Price, Settle, Maturity, Period, Basis) % SIA = 0.0803712

% Vector Input Test:
%===============

Settle = '24-Jun-1993';
Maturity = '1-Nov-1993';
Price = 95;

Yield31 = zeroyield(Price, Settle, Maturity, [2 2], [0 1]) % SIA = [0.148988; 0.1491919]
Yield31 = zeroyield(Price, Settle, Maturity, [2 2], [0 1], [1 0]) % SIA = [0.148988; 0.1491919] %EOM has NO effect

Settle = '24-Jun-1993';
Maturity = '15-Jan-2024';
Price = 9;

Yield33 = zeroyield(Price, Settle, Maturity, [2,2], [0 1]) % SIA = [0.0803721; 0.0803712]
Yield33 = zeroyield(Price, Settle, Maturity, [2,2], [0 1], [1,0]) % SIA = [0.0803721; 0.0803712] %EOM has NO effect

%Three Input arguments:
%===============
Yield3inp = zeroyield(Price, Settle, Maturity) % SIA = 0.0803721

% T-bills yield check, equivalent with Tbillyield
Tbillyld = zeroyield(99, '1-jan-1993', '1-jan-1994') % SIA = 0.01 (1.000%)
Tbillyld = zeroyield(99, '1-jan-1993', '1-jul-1993') % SIA = 0.02009 (2.009%)


% [EOF]
