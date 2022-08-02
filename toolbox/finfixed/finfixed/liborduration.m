function [pfduration, gfduration] = liborduration(SFR, Tenor, Settle)
%LIBORDURATION Duration of Libor-based interest rate swap.
%   Modified duration of fixed-side of swap in unit of years.
%
%   [PayFixDuration GetFixDuration] = liborduration(SFR, Tenor, Settle)
%
%   Inputs:
%      SFR - [Nx1] vector of a quarterly compounded swap's fixed rate in 
%            decimal. The baisis should be actual/360.
%
%    Tenor - [Nx1] vector of the swap's tenor in years. Fractional numbers will
%            be rounded upwards.
%
%   Settle - [Nx1] vector of settlement date.
%
%   Outputs:
%   PayFixDuration - [Nx1] vector of Modified durations, in years, for the 
%                    pay-fix side of the swap.
%
%   GetFixDuration - [Nx1] vector of Modified durations, in years, for the
%                    receive-fix side of the swap.
%
%   Example:
%   SFR = 0.0383;
%   Tenor = 7;
%   Settle = datenum('11-Oct-2002');
%
%   [PayFixDuration GetFixDuration] = liborduration(SFR, Tenor, Settle)
%
%   PayFixDuration =
%      -4.7567
%   GetFixDuration =
%       4.7567

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.7.6.5 $   $Date: 2004/04/06 01:08:46 $

if nargin ~= 3
    error('finfixed:liborduration:invalidInputs',...
        'Need swap rate, Settlement date, and Tenor.');
end

% expand input arguments, any mismatched size will error out
[SFR, Settle, Tenor] = ...
    finargsz(1, SFR(:), datenum(Settle), ceil(Tenor(:)));

% maximum number of payments is 4 times max of Tenor
maxcol = 4*max(Tenor);

% Initialize cf, Beginning, and End matrix
Cf = nan*zeros(length(SFR), maxcol);
BgnDates = Cf;
EndDates = Cf;

% fill in the matrices
for i = 1:length(SFR)
    Cf(i, 1:4*Tenor(i))  = SFR(i);
    Cp(i, 1:4*Tenor(i))  = SFR(i);
    Cf(i, 4*Tenor(i))    = 1 + Cf(i, 4*Tenor(i));

    datevecSettle = datevec(Settle(i));

    [minBgnDate minEndDate]  = ...
        thirdwednesday([datevecSettle(2); datevecSettle(2)+1], ...
        [datevecSettle(1); datevecSettle(1)]);

    if Settle >= minBgnDate(1)
        minBgnDate = minBgnDate(2);
        minEndDate = minEndDate(2);
    else
        minBgnDate = minBgnDate(1);
        minEndDate = minEndDate(1);
    end

    % The required Begin Data are successive 3-month EuroDollar
    % rate starting at minBgnDate
    vecminBgnDate = datevec(minBgnDate);
    vecminEndDate = datevec(minEndDate);

    % Tony's trick to expand the single row into a matrix
    % of identical rows followed by adding multiple of threes
    % into the months.
    vecminBgnDate = vecminBgnDate(ones(1,Tenor(i)*4),:);
    vecminBgnDate(:,2) = vecminBgnDate(:,2) + 3*(0:(Tenor(i)*4 - 1))';
    BgnDates(i, 1:4*Tenor(i)) = (datenum(vecminBgnDate))';

    vecminEndDate = vecminEndDate(ones(1,Tenor(i)*4),:);
    vecminEndDate(:,2) = vecminEndDate(:,2) + 3*(0:(Tenor(i)*4 - 1))';
    EndDates(i, 1:4*Tenor(i)) = (datenum(vecminEndDate))';
end

% Calculate each period's length using act/360 basis
PeriodLength = yearfrac(BgnDates, EndDates, 2);

% Compute present value of each cash flow:
FwdDiscountFactors = 1./(1 + PeriodLength.*Cp);
dcf = Cf .* cumprod(FwdDiscountFactors, 2);
dcf(isnan(dcf)) = 0;

% clean price;
price = sum(dcf, 2); % a vector;

weight = 1:maxcol;
weight = weight(ones(1,length(SFR)), :);

numerator = sum((weight.*dcf), 2);

durationfx = ((1 + SFR/4).^-1) .* (numerator ./ (4 * price));

% compute pay and receive-fixed duration:
pfduration = 0.25 - durationfx;
gfduration = -pfduration;


% [EOF]
