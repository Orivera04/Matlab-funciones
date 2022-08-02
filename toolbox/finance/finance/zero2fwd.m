function [ForwardRates, CurveDates] = zero2fwd(ZeroRates, CurveDates, Settle, ...
    varargin)
%ZERO2FWD Implied forward rate curve given a zero (spot) curve.
%   Transform a zero (i.e., spot) rate yield curve to an implied forward
%   rate curve. The zero rate curve is associated with a vector of NDATES
%   future maturities measured with respect to the current settlement date.
%
%   [ForwardRates, CurveDates] = zero2fwd(ZeroRates, CurveDates, Settle)
%   [ForwardRates, CurveDates] = zero2fwd(ZeroRates, CurveDates, Settle, ...
%                                         Compounding, Basis)
%
%   Optional Inputs: Compounding, Basis
%
%   Inputs:
%   ZeroRates   - [NDATESx1] vector of annualized zero rates, in decimal form,
%                 which in aggregate represent a zero rate yield curve for a
%                 given investment horizon relative to the current settlement
%                 date. These rates are simple interest quotations, annualized
%                 by multiplying the periodic rate by the number of compounding
%                 periods per year.
%
%   CurveDates  - [NDATESx1] vector of maturity dates associated with the
%                 ZeroRates spot curve. All dates in CurveDates must occur after
%                 the settlement date (i.e., they must correspond to future
%                 investment horizons). Dates may be expressed as serial date
%                 numbers or date strings.
%
%   Settle      - [scalar] settlement date representing the reference date for
%                 the input zero curve (e.g., the settlement date for the bonds
%                 from which the input zero curve was bootstrapped). Settle may
%                 be expressed as a serial date number or date string.
%
%   Optional Inputs:
%   Compounding - [scalar] integer representing the compounding periodicity used
%                 to annualize the input zero rates and the output implied
%                 forward rates.
%
%                 Possible values include:
%
%                   1 - annual compounding
%                   2 - semi-annual compounding (default)
%                   3 - compounding three times per year
%                   4 - quarterly compounding
%                   6 - bi-monthly compounding
%                  12 - monthly compounding
%                 365 - daily compounding
%                  -1 - continuous compounding
%
%         Basis - [scalar] integer day count basis to used to construct the input
%                 zero and output implied forward rate curves.
%
%                 Possible values include:
%                   0 - actual/actual (default)
%                   1 - 30/360 (SIA compliant)
%                   2 - actual/360
%                   3 - actual/365
%
%   Outputs:
%   ForwardRates - [NDATESx1] vector of implied forward rates, in decimal form,
%                  associated with the input zero curve ZeroRates. ForwardRates
%                  are ordered by ascending maturity. These rates are simple
%                  interest quotations, annualized by multiplying the periodic
%                  rate by the number of compounding periods per year.
%
%   CurveDates   - [NDATESx1] vector of maturity dates, expressed as serial date
%                  numbers, representing the maturity dates for each rate in
%                  ForwardRates. These dates are the same dates as those
%                  associated with the input ZeroRates, but are ordered by
%                  ascending maturity.
%
%   See also: DISC2ZERO, FWD2ZERO, PYLD2ZERO, TERMFIT, ZBTPRICE, ZBTYIELD,
%             ZERO2DISC, ZERO2PYLD

% Author(s): J. Akao and C. Bassignani, 11/21/97 Bob Winata, 11/26/2002
%            K. Lui and P. Wang, 12/2003
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.22.2.3 $   $Date: 1997/08/12 08:43:00

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           ************* GET/PARSE INPUT(S) **************         %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 3)
    error('Finance:zero2fwd:TooFewInputs', ...
        'Enter ZeroRates, CurveDates, and Settle.');
end

% Check the number of arguments passed in and set defaults.
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

% Check for sizes - must be scalars.
if any([size(Compounding), size(Basis), size(OutputCompounding), ...
        size(OutputBasis)] ~= 1)
    error ('Finance:zero2fwd:nonScalarInputs', ...
        'Compounding periodicities and bases must be scalars.')
end

% Check for invalid values.
if all(Compounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:zero2fwd:invalidCompounding', ...
        'Invalid Compounding periodicity.')
end

if all(Basis ~= [0 1 2 3])
    error('Finance:zero2fwd:invalidBasis', ...
        'Invalid Basis.')
end

if all(OutputCompounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:zero2fwd:invalidOutputCompounding', ...
        'Invalid OutPutCompounding periodicity.')
end

if all(OutputBasis ~= [0 1 2 3])
    error('Finance:zero2fwd:invalidOutputBasis', ...
        'Invalid OutPutBasis.')
end

% Sort the rates with respect to the curve dates
[Temp, SortIndex] = sort(CurveDates);
ZeroRates = ZeroRates(SortIndex);

% Settlement date "data" treatement
if CurveDates(1) <= Settle
    error('Finance:zero2fwd:invalidSettle', ...
        'Settle must precede all dates in CurveDates.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                %
%       ************* GENERATE OUTPUT(S) **************          %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get values for T in terms of fractional years from the settlement date
InYearMats = yearfrac(Settle, CurveDates, Basis);

% Get discount factors between time zero and CurveDates
if Compounding == -1
    DiscountFromSettle = exp(-ZeroRates .* InYearMats);
    
else
    DiscountFromSettle = (1 + ZeroRates/Compounding).^...
        (-InYearMats*Compounding);
end

% Compute Forward Discounts
FwdDiscounts = [DiscountFromSettle(1); ...
    DiscountFromSettle(2:end)./DiscountFromSettle(1:end-1)];

% Convert Fwd Discounts to Forward Rates
OutYearMats = yearfrac(Settle, CurveDates, OutputBasis);
FwdYearMats = [OutYearMats(1); diff(OutYearMats)];

if OutputCompounding == -1
    ForwardRates = -log(FwdDiscounts)./FwdYearMats;
    
else
    ForwardRates = OutputCompounding * ...
        (FwdDiscounts.^(-1./(FwdYearMats*OutputCompounding)) - 1);
end


% [EOF]
