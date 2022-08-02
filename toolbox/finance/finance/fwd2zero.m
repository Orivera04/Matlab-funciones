function [ZeroRates, CurveDates] = fwd2zero(ForwardRates, CurveDates, Settle, ...
    varargin)
%FWD2ZERO Zero Curve Given an Implied Forward Curve.
%
%   [ZeroRates, CurveDates] = fwd2zero(ForwardRates, CurveDates, Settle)
%   [ZeroRates, CurveDates] = fwd2zero(ForwardRates, CurveDates, Settle, ...
%                                       Compounding, Basis)
%
%   Inputs:
%   ForwardRates - [NDATESx1] vector of annualized implied forward rates in
%                  decimal form.
%
%    CurveDates  - [NDATESx1] vector of maturity dates in serial date number
%                  form which correspond to the input forward rates in
%                  ForwardRates.
%
%        Settle  - [scalar] value in serial date number form representing the
%                  settlement date for the input zero curve (i.e. the settlement
%                  date for the bonds from which the zero curve was
%                  bootstrapped).
%
%    Compounding - [scalar] value representing the rate at which the output
%                  implied forward rates are compounded when annualized.
%
%                  Possible values include:
%
%                    1 - annual compounding
%                    2 - semi-annual compounding (default)
%                    3 - compounding three times per year
%                    4 - quarterly compounding
%                    6 - bi-monthly compounding
%                   12 - monthly compounding
%                  365 - daily compounding
%                   -1 - continuous compounding
%
%         Basis  - [scalar] value representing the basis to be used in
%                  annualizing the output implied forward rates.
%
%                  Possible values include:
%                    0 - actual/actual(default)
%                    1 - 30/360 (SIA compliant)
%                    2 - actual/360
%                    3 - actual/365
%
%   Outputs:
%    ZeroRates - [NDATESx1] vector of zero rates in decimal form.
%
%   CurveDates - [NDATESx1] vector of maturity dates in serial date number form
%                representing the maturity date for each zero rate contained in
%                ZeroRates.
%
%
%   See also: DISC2ZERO, PYLD2ZERO, TERMFIT, ZBTPRICE, ZBTYIELD, ZERO2DISC,
%             ZERO2FWD, ZERO2PYLD

% Author(s): J. Akao and C. Bassignani, 11/21/97, K. Lui and P. Wang 12/2003
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.16.2.3 $   $Date: 2004/04/06 01:06:54 $


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           ************* GET/PARSE INPUT(S) **************         %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    error('Finance:fwd2zero:tooFewInputs', ...
        'Enter ForwardRates, CurveDates and Settle.');
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
        size(Basis)] ~= 1)
    error ('Finance:fwd2zero:nonScalarInputs', ...
        'Compounding periodicities and bases must be scalars.')
end

if all(Compounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:fwd2zero:invalidCompounding', ...
        'Invalid Compounding periodicity')
end

if all(Basis ~= [0 1 2 3])
    error('Finance:fwd2zero:invalidBasis', ...
        'Invalid Basis.')
end

if all(OutputCompounding ~= [-1 1 2 3 4 6 12 365])
    error('Finance:fwd2zero:invalidOutputCompounding', ...
        'Invalid OutPutCompounding periodicityss.')
end

if all(OutputBasis ~= [0 1 2 3])
    error('Finance:fwd2zero:invalidOutputBasis', ...
        'Invalid OutputBasis.')
end

% Sort the rates with respect to the curve dates
[Temp, SortIndex] = sort(CurveDates);
ForwardRates = ForwardRates(SortIndex);

if CurveDates(1) <= Settle
    error('Finance:fwd2zero:invalidSettle', ...
        'Settle must precede all dates in CurveDates.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                %
%       ************* GENERATE OUTPUT(S) **************          %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InYearMats = yearfrac(Settle, CurveDates, Basis);
FwdYearMats = [InYearMats(1); diff(InYearMats)];

% Get discount factors between time zero and CurveDates
if Compounding == -1
    FwdDiscounts = exp( -ForwardRates .* FwdYearMats);
    
else
    FwdDiscounts = (1 + ForwardRates/Compounding ).^...
        (-FwdYearMats*Compounding);
end

% Comput Discounts from settlement
DiscountFromSettle = cumprod(FwdDiscounts);

% Convert Discounts to Zero
OutYearMats = yearfrac(Settle, CurveDates, OutputBasis);

if OutputCompounding == -1
    ZeroRates = -log(DiscountFromSettle)./OutYearMats;
    
else
    ZeroRates = OutputCompounding * ...
        (DiscountFromSettle.^(-1./(OutYearMats*OutputCompounding)) - 1);
end


% [EOF]
