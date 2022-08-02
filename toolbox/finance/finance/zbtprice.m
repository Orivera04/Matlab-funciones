function [ZeroRates, CurveDates] = zbtprice(Bonds, Prices, Settle, ...
    OutputCompounding, varargin)
%ZBTPRICE Bootstrapped spot and forward curve from Bond Prices.
%
%   [ZeroRates, CurveDates] = zbtprice(Bonds, Prices, Settle)
%   [ZeroRates, CurveDates] = zbtprice(Bonds, Prices, Settle, OutputCompounding)
%
%   Optional Inputs: OutputCompounding
%
%   Inputs:
%    Bonds - The portfolio of coupon bonds from which the zero curve will be
%            derived, specifically, an NxM matrix of bond parameters where each
%            row of the matrix corresponds to an individual bond and each column
%            corresponds to a particular parameter.
%
%            The required columns (parameters) for this matrix are:
%              Maturity - [Column 1] the maturity for each bond in the
%                         portfolio in serial date number form
%
%            CouponRate - [Column 2] the coupon rate for each bond in the
%                         portfolio in decimal form
%
%            Optional columns (parameters) are:
%                    Face - [Column 3] Nominal value of bond. Default is $100.
%
%                  Period - [Column 4] the number of coupon payments per year in
%                           integer form.
%
%                           Possible values are:
%                           0,1, 2 (default), 3, 4, 6, and 12
%
%                   Basis - [Column 5] values specifying the basis for each bond
%                           in the portfolio.
%
%                           Possible values:
%                           0 - actual/actual(default)
%                           1 - 30/360 (SIA compliant)
%                           2 - actual/360
%                           3 - actual/365
%
%            EndMonthRule - [Column 6] value specifying whether or not the
%                           "end of month rule" is in effect for each bond
%                           contained in the portfolio.
%                           1 - on (default)
%                           0 - off
%
%   Prices - [Nx1] column vector containing clean price values per $100 face for
%            each bond contained in the portfolio represented by the Bonds
%            matrix.
%
%   Settle - [Scalar] value representing time zero in derivation of the zero
%            curve. Normally this is also the settlement date for the bonds
%            contained in the portfolio from which the zero curve will be
%            derived.
%
%   Optional Inputs:
%   OutputCompounding - scalar value representing the period by which the output
%                       zero rates will be compounded; the default value is
%                       semi-annual (i.e. "2") compounding.
%
%                       Possible values are:
%                       1, 2, 3, 4, 6, 12, -1.
%
%   Outputs:
%    ZeroRates - Nx1 vector containing the values for the implied zero rates for
%                each point along the investment horizon defined by a maturity
%                date.
%
%   CurveDates - Nx1 vector containing the maturity date for each zero rate
%                along the investment horizon (from time T = Settle to time
%                T = maturity of the longest dated bond in the source
%                portfolio).%
%
%   Notes: 1) In cases where the source portfolio of bonds contains more than
%             one bond with the same maturity date, the mean zero rate is
%             calculated for that maturity date.
%          2) Ensuring that the source portfolio contains a sufficient number
%             of bonds and that those bonds are evenly distributed with respect
%             to maturity date will significantly enhance the performance of
%             this function.

% Author(s): J. Akao and C. Bassignani, 11-12-97, Bob Winata 30-01-2002
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.11.2.3 $   $Date: 2004/04/06 01:06:58 $

%Check to ensure that the minimum number of arguments has been passed in
if (nargin < 3)
    error('Finance:zbtprice:tooFewInputs', ...
        'You must enter the Bonds matrix, Prices vector, and settlement date.');
end

[NumBonds, NumCols] = size(Bonds);
if (NumCols < 2)
    error('Finance:zbtprice:tooFewColumns', ...
        ['The Bonds matrix must contain at least columns ', ...
        'for the maturity date and coupon rate.'])
elseif (NumCols > 6)
    error('Finance:zbtprice:tooManyColumns', ...
        'The Bonds matrix may only contain 6 columns.')
end

% Set default columns: Face 100, Period 2, Basis 0, EOMRule 1.
Col = ones(NumBonds,1);
DefaultCols = [100*Col, 2*Col, 0*Col, 1*Col];
Bonds = [Bonds, DefaultCols(:, (NumCols-1):4)];

% Parse out bond parameters
Maturity = Bonds(:,1);
CpnRate  = Bonds(:,2);
Face     = Bonds(:,3);
Period   = Bonds(:,4);
Basis    = Bonds(:,5);
EOMRule  = Bonds(:,6);

% Prices
Prices = Prices(:);
if length(Prices)~=NumBonds
    error('Finance:zbtprice:pricesDoNotMatchBonds', ...
        sprintf('The number of Prices, %d, does not match the number of bonds %d',...
        length(Prices), NumBonds))
end

% Parse Settlement
Settle = finargdate(Settle);
if any(Settle ~= Settle(1))
    error('Finance:zbtprice:bondsMustSettleOnSameDay', ...
        'All Bonds must Settle on the same day.');
else
    Settle = Settle(1);
end

% Set OutputCompounding, OutputBasis, and PlotOptions default
if nargin<4 | isempty(OutputCompounding)
    OutputCompounding = 2;
end

%----------------------------------------------------------------------
% Generate outputs - the Zero Rates
%----------------------------------------------------------------------

% Create the cash flow amounts, dates, and time factors
[CFAmounts, CFDates, CFTimesSemi] = cfamounts(CpnRate, Settle, Maturity, ...
    Period, Basis, EOMRule, [], [], [], [], Face);

% Bootstrap a zero curve with semi-annual compounding
[ZeroRatesSemi, EndTimesSemi, CurveDates] = zerobootcf(Prices, ...
    CFAmounts, CFDates, CFTimesSemi);

% Transform to a different OutputCompounding if requested
if OutputCompounding~=2

    if OutputCompounding == -1
        ZeroRates = 2*log(1 + ZeroRatesSemi/2);
    else
        ZeroRates = OutputCompounding * ...
            ((1 + ZeroRatesSemi/2).^(2/OutputCompounding) - 1);
    end

else
    % return semi-annual rates
    ZeroRates = ZeroRatesSemi;
    EndTimes = EndTimesSemi;
end


% [EOF]
