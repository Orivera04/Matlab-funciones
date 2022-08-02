function [Times, F] = date2time(Settle, Dates, Compounding, Basis, EndMonthRule)
%DATE2TIME Periodic fixed income time and frequency from dates.
%   Compute time factors appropriate to compounded rate quotes between
%   Settle and Maturity dates.  
%
%   [Times, F] = date2time(Settle, Maturity)
%   [Times, F] = date2time(Settle, Maturity, Compounding)
%   [Times, F] = date2time(Settle, Maturity, Compounding, Basis)
%   [Times, F] = date2time(Settle, Maturity, Compounding, Basis, EndMonthRule)
%
% Inputs:
%   Settle      - Scalar date marking the settlement date. 
% 
%   Maturity    - Scalar or Nx1 vector of serial maturity dates.
% 
% Optional Inputs:
%   Compounding - Scalar value representing the rate at which the input 
%                 zero rates were compounded when annualized. Default is 2.
%
%   Basis       - Scalar or Nx1 vector of value representing the day-count 
%                 basis. Default is 0.
% 
%   EndMonthRule - Scalar or Nx1 vector of values representing the End-of-Month  
%                  rule. Default is 1.
%
%   Output:
%     Times   - Time factors appropriate to compounded rate quotes between
%               Settle and Maturity dates.  
%
%     F       - Frequency.
%
%   See Also CFTIMES, RATE2DISC, DISC2RATE.

%   Author(s): J. Akao
%   Copyright 1995-2003 The MathWorks, Inc. 
%   $Revision: 1.9.2.2 $  $Date: 2003/08/29 04:45:47 $

%-------------------------------------------------
%Checking input arguments
%------------------------------------------------- 
if (nargin<5 | isempty(EndMonthRule))
  EndMonthRule = 1;
end

if (nargin<4 | isempty(Basis))
  Basis = 0;
end

if (nargin<3 | isempty(Compounding ))
  Compounding = 2;
end

if (length(Compounding) > 1)
  error('Compounding must be a scalar value')
end

%------------------------------------------------------------------------
% Compute time factors for the dates
% Either work on a daily basis or from semi-annual time factors
% 
% Compounding = {1, 2, 3, 4, 6, 12} (Periodic)
%   D = (1 + Z/F)^(-T)
%   T = Tsemi * F/2
%   F = Compounding
% Compounding = -1 (Continuous)
%   D = exp(-T*Z/F)
%   T = Tsemi *F/2
%   F = 1
% Compounding = 365 (Daily)
%   D = (1 + Z/F)^(-T)
%   Basis 0 (actual/actual) F = ?   , T = daysact
%   Basis 1 (30/360)        F = 360 , T = days360
%   Basis 2 (actual/360)    F = 360 , T = daysact
%   Basis 3 (actual/365)    F = 365 , T = days365
%
%------------------------------------------------------------------------

switch Compounding
  case 365
    % Daily
    F = 365;

    if ~isempty(Settle) & ~isempty(Dates)
      Times = daysdif(Settle, Dates, Basis);
    else
      Times = [];
    end
    
  case {1, 2, 3, 4, 6, 12}
    % Periodic
    F = Compounding;

    if ~isempty(Settle) & ~isempty(Dates)
      Tsemi = semitimes(Settle, Dates, 0, Basis, EndMonthRule);
      Times = (F/2) * Tsemi;
    else
      Times = [];
    end
    
  case -1
    % Continuous (annual)
    F = 1;

    if ~isempty(Settle) & ~isempty(Dates)
      Tsemi = semitimes(Settle, Dates, 0, Basis, EndMonthRule);
      Times = (F/2) * Tsemi;
    else
      Times = [];
    end
    
  otherwise
    error('Invalid Compounding specified')
end

%------------------------------------------------------------------------
% faster semi-annual times
%------------------------------------------------------------------------
function [TFactors] = semitimes(varargin)
%SEMITIMES Faster semi-annual times for zeros.
% TFactors = semitimes(Settle, Maturity, Period, Basis, EOM);
%
[Dummy, Settle, Maturity, Period, Basis, EOM] = instargbond(0, varargin{:});
NumBonds = length(Maturity);
Period(:) = 2;

% Make sure Basis didn't get expanded
%Basis = Basis(1);

% find the previous synced coupon date
PrevDate = cpndatepq(Settle, Maturity, Period, Basis, EOM);

% Coupon structure is synced with Maturity.
% Do a basic day count calculation to find the number of months and
% count the coupons.
DaysYear=zeros(size(Basis));
DaysYear(Basis==0) = 365.25;
DaysYear(Basis==1 | Basis==2) = 360;
DaysYear(Basis==3) = 365;
MonthsToMaturity = round( daysdif(PrevDate,Maturity,Basis)*12 ./ DaysYear );

% Whole or partial coupon periods Settle to Maturity
CpnsToMaturity = MonthsToMaturity .* Period/12;

if rem(MonthsToMaturity, 12./Period)~=0
  warning('you missed');
  CpnsToMaturity = round(CpnsToMaturity);
end

% Subtract the portion of the coupon period which has passed already
TFraction = zeros(NumBonds,1);
Ind = ( PrevDate < Settle);
if any(Ind)
  % find the period size
  BasisEx = Basis(ones(size(Ind)));
  NextDate = cpndatenq(Settle(Ind), Maturity(Ind), Period(Ind), BasisEx(Ind), ...
                       EOM(Ind));
  DaysPer = dayspersz(PrevDate(Ind), NextDate, Basis(Ind));

  % find the days elapsed
  DaysAcr = daysaccru(PrevDate(Ind), Settle(Ind), Basis(Ind));
  
  TFraction(Ind) = DaysAcr./DaysPer;
end

TFactors = CpnsToMaturity - TFraction;

%----------------------------------------------------------------------------

function d = daysaccru(d1,d2,basis)
%DAYSACCRU Days between dates for any day count basis.
%       D = DAYSACCRU(D1,D2,BASIS) returns the number of
%       days between D1 and D2 using the given day count
%       basis. Enter dates as serial date numbers or date strings.  
%       BASIS is the day-count basis: 0 = actual/actual (default), 
%       1 = 30/360, 2 = actual/360, 3 = actual/365.
%

if nargin < 2
  error('Please enter D1 and D2.')
end
if isstr(d1) | isstr(d2) 
  d1 = datenum(d1);
  d2 = datenum(d2);
end
if nargin < 3
  basis = zeros(size(d1));
end
if ~(all(all(basis == 0 | basis == 1 | basis == 2 | basis == 3)))
  error('Invalid day count basis specified.')
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
if checksiz([size(d1);size(d2);size(basis)],mfilename);return;end

d = zeros(size(d1));

% (0) Actual/Actual, (2) Actual/360, (3) Actual/365
i = find(basis == 0 | basis == 2 | basis == 3);
if ~isempty(i);d(i) = daysact(d1(i),d2(i));end

% (1) 30/360
i = find(basis == 1);
if ~isempty(i);d(i) = days360(d1(i),d2(i));end

%----------------------------------------------------------------------------
%----------------------------------------------------------------------------

function d = dayspersz(d1,d2,basis)
%DAYSPERSZ Days between dates for any day count basis.
%       D = DAYSPERSZ(D1,D2,BASIS) returns the number of
%       days between D1 and D2 using the given day count
%       basis.   Enter dates as serial date numbers or date strings.  
%       BASIS is the day-count basis: 0 = actual/actual (default), 
%       1 = 30/360, 2 = actual/360, 3 = actual/365.
%

if nargin < 2
  error('Please enter D1 and D2.')
end
if isstr(d1) | isstr(d2) 
  d1 = datenum(d1);
  d2 = datenum(d2);
end
if nargin < 3
  basis = zeros(size(d1));
end
if ~(all(all(basis == 0 | basis == 1 | basis == 2 | basis == 3)))
  error('Invalid day count basis specified.')
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
if checksiz([size(d1);size(d2);size(basis)],mfilename);return;end

d = zeros(size(d1));

% Actual/Actual
i = find(basis == 0);
if ~isempty(i);d(i) = daysact(d1(i),d2(i));end

% 30/360, Actual/360
i = find(basis == 1 | basis == 2);
if ~isempty(i);d(i) = days360(d1(i),d2(i));end

% Actual/365
i = find(basis == 3);
if ~isempty(i);d(i) = days365(d1(i),d2(i));end





