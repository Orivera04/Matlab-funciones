function [ZeroRatesZP, CurveDates] = pyld2zero(ParRates, CurveDates, Settle, ...
    varargin)
%PYLD2ZERO Zero curve given a par-yield curve.
%
%   [ZeroRates, CurveDates] = pyld2zero(ParRates, CurveDates, Settle)
%   [ZeroRates, CurveDates] = pyld2zero(ParRates, CurveDates, Settle, ...
%                                       Compounding, Basis, OutputCompounding)
%
%   Optional Inputs: Compounding, Basis, OutputCompounding
%
%   Inputs:
%     ParRates - [NDATESx1] vector of annualized par yields (par yields = coupon
%                rates) in decimal form where N is the number of par bond
%                maturities.
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
%                       Par rates were compounded when annualized; the default
%                       is the value for Compounding.
%
%   Outputs:
%    ZeroRates - [NDATESx1] vector of zero rates in decimal form.
%
%   CurveDates - [NDATESx1] vector of maturity dates in serial date number form
%                representing the maturity date for each zero rate contained in
%                ZeroRates.
%
%   See also: DISC2ZERO, FWD2ZERO, TERMFIT, ZBTPRICE, ZBTYIELD, ZERO2FWD,
%             ZERO2DISC, ZERO2PYLD

% Author: J. Akao and C. Bassignani, 11-19-97
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.17.2.4 $   $Date: 2004/04/06 01:06:56 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           ************* GET/PARSE INPUT(S) **************         %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check inputs; set defaults as necessary.
if (nargin < 3)
     error('Finance:pyld2zero:tooFewInputs', ...
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
    error ('Finance:pyld2zero:nonScalarInputs', ...
        'Compounding periodicities and bases must be scalars.')
end

% Checking for invalid values
if (all(Compounding ~= [-1 1 2 3 4 6 12 365]))
     error('Finance:pyld2zero:invalidCompounding', ...
         'Invalid Compounding periodicity.')
end

if all(Basis ~= [0 1 2 3])
     error('Finance:pyld2zero:invalidBasis', ...
         'Invalid Basis.')
end

if (all(OutputCompounding ~= [-1 1 2 3 4 6 12 365]))
     error('Finance:pyld2zero:invalidOutputCompounding', ...
         'Invalid OutputCompounding periodicity.')
end

if all(OutputBasis ~= [0 1 2 3])
     error('Finance:pyld2zero:invalidOutputBasis', ...
         'Invalid OutPutBasis.')
end

% Sort the rates with respect to the curve dates
[CurveDates, SortIndex] = sort(CurveDates);
ParRates = ParRates(SortIndex);

% We assume that Par Yield at Settle is not
% unnecessarily given => user realizes that it
% does not matter.
tag = 0;

if min(CurveDates) < Settle
    error('Finance:pyld2zero:settleValueTooLarge', ...
        'Settle must be less than all of CurveDates.')
else
    if CurveDates(1) == Settle % user gives par rates at Settle
       % shift one element down
        CurveDates = CurveDates(2:end);
        ParRates = ParRates(2:end);
        tag = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                %
%       ************* GENERATE OUTPUT(S) **************          %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NumBonds = length(ParRates);
Col = ones(NumBonds, 1);

% turn the input zero rates to semi-annual
if OutputCompounding~=2
    
    if OutputCompounding == -1 % Input zero Rates is continuous
        ParRates = 2*(exp(ParRates/2) - 1);
    else
        ParRates = 2*((1+ParRates/OutputCompounding).^...
            (OutputCompounding/2) - 1);
    end
    % do nothing if Input Compounding is 2
end

% Remember, that Par Prices is Clean Prices when input to ZBTPRICE
ParPrices = 100*Col;

Bonds = [CurveDates ParRates 100*Col 2*Col OutputBasis*Col 1*Col];

%Bootstrap zero rates from the par bonds by calling the ZBTPRICE function
[ZeroRatesZP, CurveDates] = zbtprice(Bonds, ParPrices, ...
    Settle, Compounding);

if tag
    ZeroRatesZP(2:end+1) = ZeroRatesZP;
    CurveDates(2:end+1) = CurveDates;
    CurveDates(1) = Settle;
end


% [EOF]
