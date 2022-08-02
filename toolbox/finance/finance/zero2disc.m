function [DiscRates, CurveDates] = zero2disc(ZeroRates, CurveDates, Settle,...
    Compounding, Basis)
%ZERO2DISC Discount Curve Given a Zero Curve.
%   Given a zero curve and a set of maturity dates as inputs, this function
%   generates a set of discount factors, or discount curve, for the investment
%   horizon represented by those maturity dates.
%
%   [DiscRates, CurveDates] = zero2disc(ZeroRates, CurveDates, Settle, ...
%        Compounding, Basis)
%
%   Optional Inputs: Compounding, Basis
%
%   Inputs:
%    ZeroRates - [NDATESx1] vector of zero rates in decimal form which in
%                aggregate represent a zero curve for a given investment
%                horizon.
%
%   CurveDates - [NDATESx1] vector of maturity dates in serial date number form
%                which correspond to the input zero rates.
%
%      MSettle - [scalar] value in serial date number form representing the
%                settlement date for the input zero curve (i.e. the settlement
%                date for the bonds from which the zero curve was bootstrapped).
%
%
%   Optional Inputs:
%   Compounding - [scalar] value representing the rate at which the input zero
%                 rates were compounded when annualized.
%
%                 Possible values include:
%                   1 - annual compounding or one payment per year
%                   2 - semi-annual compounding (default)
%                   3 - compounding three times per year
%                   4 - quarterly compounding
%                   6 - bi-monthly compounding
%                  12 - monthly compounding
%                 365 - daily compounding
%                  -1 - continuous compounding
%
%         Basis - [scalar] value representing the basis that was used in
%                 annualizing the input zero rates.
%
%                 Possible values include:
%                 0 - actual/actual(default)
%                 1 - 30/360
%                 2 - actual/360
%                 3 - actual/365
%
%   Outputs:
%    DiscRates - [NDATESx1] vector of discount factors in decimal form.
%
%   CurveDates - [NDATESx1] vector of maturity dates in serial date number form
%                representing the maturity date for each discount factor
%                contained in DiscRates.
%
%
%   See also: DISC2ZERO, FWD2ZERO, PYLD2ZERO, TERMFIT, ZBTPRICE, ZBTYIELD, 
%             ZERO2FWD, ZERO2PYLD

% Author(s): C. Bassignani, 11/21/97, P.Wang and K.Lui 12/03
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.13.2.3 $   $Date: 2004/04/06 01:07:00 $

% Error check
if nargin < 3
    error('Finance:zero2disc:tooFewInputs',...
        'Enter ZeroRates, CurveDates, and Settle.');
end

% Check the number of arguments passed in and set defaults
if nargin < 5 || isempty(Basis)
    Basis = 0;
end

if nargin < 4 || isempty(Compounding)
    Compounding = 2;
end

% Parse compounding argument
if length(Compounding(:)) > 1
    error('Finance:zero2disc:scalarCompoundingValueRequired',...
        'Compounding periodicity must be scalar.')
end

if all(Compounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:zero2disc:invalidCompounding',...
        'Invalid Compounding periodicity.')
end

% Parse basis argument
if length(Basis(:)) > 1
    error('Finance:zero2disc:scalarBasisRequired',...
        'Basis must be scalar.')
end

if all(Basis ~= [0 1 2 3])
    error('Finance:zero2disc:invalidBasis',...
        'Invalid basis.')
end

% Sort the rates with respect to the curve dates
[CurveDates, SortIndex] = sort(CurveDates);
ZeroRates = ZeroRates(SortIndex);

%Set continuous Input compounding flag
InContCompFlag = 0;
if (Compounding == -1)
     InContCompFlag = 1;
end

% Convert dates to serial dates
Maturity = datenum(CurveDates);
Settle = datenum(Settle);

% DiscRates = rate2disc(Compounding, ZeroRates, Maturity, [] , Settle, Basis);

%Get the maturity values for T in fractions of a year
InYearMats = yearfrac(Settle, CurveDates, Basis);

%Check compounding flag and convert zero rates to discount factor
if (InContCompFlag)
     %Continuous compounding
     DiscRates = exp(-ZeroRates .* InYearMats);
else
     %Discrete compounding
     DiscRates = (1 + ZeroRates ./ Compounding) .^ (-InYearMats .*...
          Compounding);
end


% [EOF]
