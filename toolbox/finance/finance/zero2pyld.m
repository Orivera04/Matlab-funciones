function [ParRates, CurveDates] = zero2pyld(ZeroRates, CurveDates, Settle, ...
    varargin)
%ZERO2PYLD Par curve given a zero yield curve.
%
%   [ParRates, CurveDates] = zero2pyld(ZeroRates, CurveDates, Settle)
%   [ParRates, CurveDates] = zero2pyld(ZeroRates, CurveDates, Settle, ...
%                                      Compounding, Basis, OutputCompounding)
%
%   Optional Inputs: Compounding, Basis, OutputCompounding
%
%   Inputs:
%    ZeroRates - [NDATESx1] vector of annualized zero rates in decimal form
%                which in aggregate represent a zero curve for a given
%                investment horizon.
%
%   CurveDates - [NDATESx1] vector of maturity dates in serial date number form
%                which correspond to the input zero rates.
%
%       Settle - [scalar] value in serial date number form representing the
%                settlement date for the input zero curve (i.e. the settlement
%                date for the bonds from which the zero curve was bootstrapped).
%
%   Optional Inputs:
%         Compounding - [scalar] value representing the rate at which the output
%                       implied forward rates are compounded when annualized.
%
%                       Possible values include:
%                         1 - annual compounding
%                         2 - semi-annual compounding (default)
%                         3 - compounding three times per year
%                         4 - quarterly compounding
%                         6 - bi-monthly compounding
%                        12 - monthly compounding
%                       365 - daily compounding
%                        -1 - continuous compounding
%
%               Basis - [scalar] value representing the basis to be used in
%                       annualizing the output implied forward rates.
%
%                       Possible values include:
%                       0 - actual/actual(default)
%                       1 - 30/360 (SIA compliant)
%                       2 - actual/360
%                       3 - actual/365
%
%   OutputCompounding - [scalar] value representing the rate at which the input
%                       zero rates were compounded when annualized.
%                       The default is the value for Compounding.
%
%   Outputs:
%     ParRates - [NDATESx1] vector of par bond coupon rates (yields).
%
%   CurveDates - [NDATESx1] vector vector of maturity dates in serial date
%                number form representing the maturity date for each par bond.
%
%   See also: DISC2ZERO, FWD2ZERO, PYLD2ZERO, TERMFIT, ZBTPRICE, ZBTYIELD,
%             ZERO2DISC, ZERO2FWD

% Author: J. Akao and C. Bassignani, 11-25-97
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.17.2.3 $   $Date: 2004/04/06 01:07:02 $


% Check inputs; set defaults as necessary.
if nargin < 3
    error('Finance:zero2pyld:invalidNumberOfInputs', ...
        'Enter ZeroRates, CurveDates, and Settle.');
end

% Check the number of arguments passed in and set defaults
if nargin < 4 || isempty(varargin{1})
    Compounding = 2;
else
    Compounding = varargin{1};
end

if nargin < 5 || isempty(varargin{2})
    Basis = 0;
else
    Basis = varargin{2};
end

if nargin < 6 || isempty(varargin{3})
    OutputCompounding = Compounding;
else
    OutputCompounding = varargin{3};
end

if nargin < 7 || isempty(varargin{4})
    OutputBasis = Basis;
else
    OutputBasis = varargin{4};
end

% Check for sizes - must be scalars
if any([size(Compounding), size(Basis), size(OutputCompounding), ...
        size(OutputBasis)] ~= 1)
    error ('Finance:zero2pyld:nonScalarInputs', ...
        'Compounding periodicities and bases must be scalars.')
end

% Checking for invalid values
if all(Compounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:zero2pyld:invalidCompounding', ...
        'Invalid Compounding periodicity.')
end

if all(Basis ~= [0 1 2 3])
    error('Finance:zero2pyld:invalidBasis', ...
        'Invalid Basis.')
end

if all(OutputCompounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:zero2pyld:invalidOutputCompounding', ...
        'Invalid OutputCompounding periodicity.')
end

if all(OutputBasis ~= [0 1 2 3])
    error('Finance:zero2pyld:invalidOutputBasis', ...
        'Invalid OutPutBasis.')
end

% Assume that Par Yield at Settle is not given.
tag = 0;
if min(CurveDates) < Settle
    error('Finance:zero2pyld:settleValueTooLarge', ...
        'Settle must be less than all of CurveDates')

else
    % Par rates at Settle
    if CurveDates(1) == Settle
        CurveDates = CurveDates(2:end); % Shift one element down
        ZeroRates = ZeroRates(2:end);
        tag = 1;
    end
end


% Sort the rates with respect to the curve dates
[Temp, SortIndex] = sort(CurveDates);
ZeroRates = ZeroRates(SortIndex);

% Find the fraction of the period for par bond accrued interest
AIfraction = accrfrac(Settle, CurveDates, Compounding, Basis, 1);

% Find the cash flow dates of all the par bonds
ParCFDates = cfdates(Settle, CurveDates, Compounding, Basis, 1);
CFMask = ~isnan(ParCFDates);
NumCFbyBond = sum(CFMask,2);
NumBonds = size(ParCFDates,1);

% Compute discounts at those dates based on the zero curve
% Baseline zeros over the interval [0, CurveDates(end)]
CurveYears = [0; yearfrac(Settle, CurveDates, OutputBasis)];
CurveZeros = [ZeroRates(1); ZeroRates];

% Zero rates at the cash flows: interpolated from the zero curve (col vector)
CFYears = yearfrac(Settle, ParCFDates(CFMask), OutputBasis);
CFZeros = interp1(CurveYears, CurveZeros, CFYears);

% Discount factors at the cash flows: from the zero curve and arranged by bond
% Note: the function could support continuous input compounding here
CFDisc = zeros(size(ParCFDates));
CFDisc(CFMask) = (1 + CFZeros/OutputCompounding).^(-CFYears*OutputCompounding);

% Sum the discount factors for each bond
CFDsum = sum(CFDisc,2);
CFDlast = zeros(NumBonds,1);

for i=1 : NumBonds
    CFDlast(i) = CFDisc(i, NumCFbyBond(i)); % final discount factor for each bond
end

% Coupon rates which price the par bond correctly
ParRates = Compounding*( 1 - CFDlast )./( CFDsum - AIfraction );

% If CurveSate(1) == Settle
if tag
    ParRates(2:end+1) = ParRates;
    CurveDates(2:end+1) = CurveDates;
    CurveDates(1) = Settle;
end


% [EOF]
