function Dates = time2date(varargin)
%TIME2DATE Periodic fixed dates from a time vector corresponding to compounding value.
%   Compute Dates corresponding to compounded rate quotes between Settle and
%   time factors.
%
%   Maturity = time2date(Settle, Times)
%   Maturity = time2date(Settle, Times, Compounding)
%   Maturity = time2date(Settle, Times, Compounding, Basis)
%   Maturity = time2date(Settle, Times, Compounding, Basis, EndMonthRule)
%
% Inputs:
%   Settle - Scalar date marking the settlement date. 
% 
%   Times  - Nx1 vector of time factors corresponding to Compounding value.
% 
% Optional Inputs:
%   Compounding  - Scalar value representing the rate at which the input 
%                  zero rates were compounded when annualized. Default is 2.
%
%   Basis        - Scalar value representing the day-count basis.
%                  Default is 0.
% 
%   EndMonthRule - Scalar value representing the End-of-Month rule. 
%                  Default is 1.
%
%   Output:
%     Maturity   - Dates corresponding to compounded rate quotes between Settle and
%                  time factors. 
%
% Note: This is the inverse of DATE2TIME. Method used is vectorized 
%       binary search. The norms has been preset to within 0.1 days.
%
% See Also CFTIMES, CFAMOUNTS,DATE2TIME

%   Author(s): B. Winata
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:00 $

%----------------------------------------------------
% scalar version
%----------------------------------------------------
if nargin < 2
    error ('Need at least Settle and Times')
else
    Settle = datenum(varargin{1});
    Times = varargin{2};
end

if nargin < 3 | isempty(varargin{3})
    Compounding = 2;
else
    Compounding = varargin{3};
end

if nargin < 4 | isempty(varargin{4})
    Basis = 0;
else
    Basis = varargin{4};
end

if nargin < 5 | isempty(varargin{5})
    EndMonthRule = 1;
else
    EndMonthRule = varargin{5};
end

% First resize non Matrix inputs
[Settle, Times, Basis, EndMonthRule] = finargsz(1, Settle(:), Times(:), Basis(:), EndMonthRule(:));

% Some people think it is 360 days in a year.
% Others 365 days. Some even 366 days.
% We will say that  it is no more than 400 days. 
lowerbound = Settle;

if Compounding + 1
    upperbound = Settle + 400 * Times ./ Compounding;
else % treat continuous compounding separately
    upperbound = Settle + 400 * Times;
end


% Start from the middle of range
TempDate   = (upperbound + lowerbound)/2;

%Initialize at whatever large value come to mind;
TempDateChange = 1000*ones(size(lowerbound));
norms = 1000;

% vectorized solver
while norms > 0.1
    TempTimes = date2time(Settle, TempDate, Compounding, Basis, EndMonthRule);
    
    if all(abs(TempTimes - Times) < eps)
        break
    end
    
    indexgt = find(TempTimes>Times);
    indexlt = find(TempTimes<Times);
    
    % TempTimes > Times
    TempDateChange(indexgt) = 0.5*(upperbound(indexgt)-lowerbound(indexgt));
    upperbound(indexgt) = TempDate(indexgt);        
    TempDate(indexgt) = (upperbound(indexgt) + lowerbound(indexgt))*0.5;
    % TempTimes < Times
    TempDateChange(indexlt) = 0.5*(upperbound(indexlt)-lowerbound(indexlt));
    lowerbound(indexlt) = TempDate(indexlt);
    TempDate(indexlt) = (upperbound(indexlt) + lowerbound(indexlt))*0.5;
    % The norm is to detect that the maximum of change of dates is < 0.1
    norms = max(TempDateChange(union(indexgt, indexlt)));
end   

% Get rid of the hour, min, sec.
Dates = floor(TempDate);