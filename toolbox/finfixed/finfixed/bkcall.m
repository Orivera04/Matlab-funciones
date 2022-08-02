function [CallPrices, PutPrices] = bkcall(varargin)
%BKCALL Black's model for pricing European call options on bonds.
%   Compute the prices of NOPTIONS European call options on bonds using 
%   Black's model.
%
%   CallPrice = bkcall(Strike, ZeroData, Sigma, BondData, Settle, Expiry)
%   CallPrice = bkcall(Strike, ZeroData, Sigma, BondData, Settle, Expiry,
%     Period, Basis, EndMonthRule, InterpMethod, StrikeConvention)
%
% Optional Inputs: Period, Basis, EndMonthRule, InterpMethod, StrikeConvention
%
% Inputs:
%   Strike - Scalar or NOPTIONS x 1 vector of option strike prices.
%
%   ZeroData - NRATES x 2 (optionally, NRATES x 3) matrix containing zero 
%     (i.e., spot) rate information used to discount future cash flows. The 
%     first column specifies the serial maturity date associated with the 
%     zero rate in the second column. The rates in column two are annualized
%     zero rates, in decimal form, appropriate for discounting cash flows 
%     that occur on the date specified in the first column. All dates must
%     occur after the settlement date (i.e., dates must correspond to future 
%     investment horizons), and must be in ascending order.
%
%     The optional third column specifies the annual compounding frequency
%     used to annualize the input zero rates. Possible values include:
%  
%        1 = annual compounding
%        2 = semi-annual compounding (default)
%        3 = compounding three times per year
%        4 = quarterly compounding
%        6 - bi-monthly coupons
%       12 = monthly compounding
%       -1 = continuous compounding
%
%   Sigma - Scalar or NOPTIONS x 1 vector of annualized price volatilities
%     required by Black's model.
%
%   BondData - Row vector with 3 (optionally, 4) columns or an NOPTIONS x 3
%     (optionally, NOPTIONS x 4) matrix specifying the characteristics of 
%     the underlying bond(s). The first column is the clean price (i.e., the
%     price excluding accrued interest), the second column is the decimal
%     coupon rate, and the third column is the serial maturity date of the
%     bond. The optional fourth column is the face value of the bond. If
%     unspecified, the face value is assumed be 100.
%
%   Settle - Scalar serial settlement date number, or date string, of the
%     options. Settle also represents the time zero reference date for the
%     input zero curve.
%
%   Expiry - Scalar or NOPTIONS x 1 vector of option serial maturity dates.
%
% Optional Inputs:
%   Period - Scalar or NOPTIONS x 1 vector of coupon payment periodicities of 
%     the underlying bonds. Possible integer values include:
%
%        0 - no coupons (i.e., a zero-coupon bond)
%        1 - one coupon per year
%        2 - semi-annual coupons  (default)
%        3 - three coupons per year
%        4 - quarterly coupons
%        6 - bi-monthly coupons
%       12 - monthly coupons
%
%   Basis - Scalar or NOPTIONS x 1 vector of day count bases of the 
%     underlying bonds. Possible integer values include:
%
%        0 - actual/actual (default)
%        1 - 30/360 (SIA compliant)
%        2 - actual/360
%        3 - actual/365
%
%   EndMonthRule - Scalar or NOPTIONS x 1 vector of end-of-month rules. 
%     EndMonthRule = 0 indicates that the rule is NOT in effect. 
%     EndMonthRule = 1 (default) indicates that the rule is in effect and
%     that bonds paying coupons on the last day of the month will always
%     pay on the last day of the month.
%	
%   InterpMethod - Scalar integer zero curve interpolation method. For cash
%     flows that do not fall on a date found in the ZeroData spot curve (see
%     above), this value indicates the method used to interpolate the 
%     appropriate zero discount rate. Possible integer values include:
%
%        0 - nearest neighbor interpolation
%        1 - linear interpolation (default)
%        2 - shape-preserving piecewise cubic interpolation
%
%   StrikeConvention - Scalar or NOPTIONS x 1 vector of option contract
%     strike price conventions. StrikeConvention = 0 defines the strike
%     price as the cash (i.e., dirty) price paid for the underlying bond. 
%     StrikeConvention = 1 defines the strike price as the quoted (i.e., 
%     clean) price paid for the bond. By default, the clean price convention
%     is assumed, and the accrued interest of the underlying bond at option
%     expiration is added to the input Strike price when evaluating Black's
%     model.
%
% Outputs:
%   CallPrice - NOPTIONS x 1 vector of prices of European call options on 
%     bonds derived from Black's model.
%
% Note:
%   In the event cash flows occur beyond the dates spanned by the input zero
%   curve ZeroData, the appropriate zero rate for discounting such cash flows
%   is obtained by simply extrapolating the nearest rate on the curve. In
%   other words, if a cash flow occurs before the first or after the last 
%   date found on the input zero curve, a flat zero curve is assumed.
%
% See also BKPUT, BLKPRICE, INTERP1.

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.9.2.5 $   $Date: 2004/04/06 01:08:37 $

%
% Reference:
%   Hull, J.C., "Options, Futures, and Other Derivatives", Prentice Hall, 
%     5th edition, 2003. See pages 287-288, 508-515.
%

if length(varargin) == 1
   varargin = varargin{:};
end

if length(varargin) < 6
   error('finfixed:bkcall:TooFewInputs', ...
				     'Specify at least 6 input arguments.')
end

[message, Output] = errorcheck('bkcall', varargin);
error(message);

Strike       = Output {1};
ZeroDates    = Output {2};
ZeroRates    = Output {3};
Frequency    = Output {4};
Sigma        = Output {5};
CleanPrice   = Output {6};
CouponRate   = Output {7};
Maturity     = Output {8};
Face         = Output {9};
Settle       = Output{10};
Expiry       = Output{11};
Period       = Output{12};
Basis        = Output{13};
EndMonthRule = Output{14};
method       = Output{15};
Convention   = Output{16};

%
% Enforce input argument consistency.
%

try
	
  [Sigma     , CleanPrice  , ...
   Strike    , Expiry      , ...
   Maturity  , Period      , ...
   Basis     , EndMonthRule, ...
   Convention, CouponRate  , ...
   Face      ] = finargsz('scalar'     , Sigma     , CleanPrice, Strike, ...
  	                        Expiry      , Maturity  , Period    , Basis , ...
                           EndMonthRule, Convention, CouponRate, Face);
catch
   error('finfixed:bkcall:InconsistentDimensions', ...
         'Inputs must be scalars or conforming matrices.')
end

nOptions = numel(Strike);  % # of options.

%
% Generate bond cash flows and payment dates.
%

[CFlowAmounts, CFlowDates] = cfamounts(CouponRate, Settle, Maturity    , ...
                                       Period    , Basis , EndMonthRule, ...																																				
                                       [], [], [], []    , Face);
%
% Extract accrued interest from cash flow stream.
%

accruedInterest = -CFlowAmounts(:,1);
CFlowAmounts    =  CFlowAmounts(:,2:end);
CFlowDates      =  CFlowDates  (:,2:end);

%
% Ensure all zero curve rates are continuously-compounded.
%

i            = (Frequency > 0);
ZeroRates(i) = Frequency(i) .* log(1 + ZeroRates(i)./Frequency(i));

%
% Extrapolate the zero (i.e., spot) curve to guarantee successful
% interpolation of cash flow dates. The extrapolation simply 
% assumes a flat yield curve both prior to the first curve date
% and after the last curve date.
%

if max(Expiry) > ZeroDates(end)
   ZeroDates = [Settle       ; ZeroDates ;    max(Expiry)];
   ZeroRates = [ZeroRates(1) ; ZeroRates ; ZeroRates(end)];
else
   ZeroDates = [Settle       ; ZeroDates];
   ZeroRates = [ZeroRates(1) ; ZeroRates];
end

%
% Pre-allocate the parameters needed for Black's model.
%

FwdPrice = zeros(nOptions,1);  % Forward bond price.
zT       = zeros(nOptions,1);  % Zero rate for (0 <= t <= T).
T        = zeros(nOptions,1);  % Time to expiry of the option (years).

%
% Now compute the model parameters.
%

for iOption = 1:nOptions

%
%   Extract coupons paid during the life of the option. Notice 
%   that a coupon paid on the option expiration date is included
%   in the life of the option (see Hull, Example 23.2, page 550).
%
    relevantDates = CFlowDates(iOption, CFlowDates(iOption,:) <= Expiry(iOption));

    if isempty(relevantDates)
%
%      Since no coupons are paid during the life of the option, the
%      present value is zero.
%
       I = 0;

				else

       relevantCFs   = CFlowAmounts(iOption, 1:length(relevantDates));			
       relevantDates = relevantDates(:);
       relevantCFs   = relevantCFs(:);
%
%      Time between option settlement and coupon payment dates 
%      during the life of the option (in years).
%
       TimeToCFs = yearfrac(Settle, relevantDates, Basis(iOption));
% 
%      Interpolate into the zero curve to approximate the zero rates
%      required to discount the bond cash flows.
%
       z  = interp1(ZeroDates, ZeroRates,   relevantDates, method);
% 
%      Compute the present value of all coupons paid during the life
%      of the option.
%
       I = sum(relevantCFs .* exp(-z .* TimeToCFs));

    end
%
%   Time between option settlement and option maturity (in years).
%
    T(iOption) = yearfrac(Settle, Expiry(iOption), Basis(iOption));
% 
%   Interpolate into the zero curve to approximate the zero rates
%   required to discount the adjusted bond price at option maturity.
%
    zT(iOption) = interp1(ZeroDates, ZeroRates, Expiry(iOption), method);
% 
%   Compute the current forward cash (i.e., dirty) bond price.
%
    DirtyPrice        =  CleanPrice(iOption) + accruedInterest(iOption);
    FwdPrice(iOption) = (DirtyPrice - I) .* exp(zT(iOption) .* T(iOption));
% 
%   The strike price, as defined in Black's model, must be the cash 
%   (i.e., dirty) strike price (see Hull, 5th edition, page 512).
%
%   If the terms of the option contract specify the strike price as
%   the quoted (i.e., clean) price of the bond, then add the accrued
%   interest of the bond payable at expiration of the option before
%   application of Black's model.
%
%   Note that if the coupon payment periodicity is zero, then the 
%   accrued interest is, by definition, zero. Including this condition
%   in the IF test below simply avoids a divide-by-zero error.
%
    if (Convention(iOption) > 0) && (Period(iOption) > 0)
       fraction = accrfrac(Expiry(iOption), Maturity(iOption), ...
                           Period(iOption), Basis(iOption)   , ...
                           EndMonthRule(iOption));

       AI       = fraction * Face(iOption) * CouponRate(iOption) / Period(iOption);
       Strike(iOption) = Strike(iOption) + AI;
    end

end

%
% Call Black's model valuation function.
%

[CallPrices, PutPrices] = blkprice(FwdPrice, Strike, zT, T, Sigma);



%
% Input argument checking & parameter assignment for BKCALL and BKPUT.
%

function [Message, Output] = errorcheck(Function, varargin)

varargin = varargin{:};
nInputs  = length(varargin);
Output   = [];

%
% Initialize the message structure.
%

Message.message    = '';  
Message.identifier = '';

Strike        = varargin{1}(:);
ZeroCurveData = varargin{2};
nColumns      = size(ZeroCurveData,2);

if nColumns < 2
   Message.identifier = ['finfixed:' Function ':InvalidZeroData'];
   Message.message    =  'ZeroData matrix must have 2 or 3 columns.';
   return
end

ZeroDates = ZeroCurveData(:,1);
ZeroRates = ZeroCurveData(:,2);

if nColumns == 3
   Frequency = ZeroCurveData(:,3);
   a         = repmat(Frequency, 1, 7);
   b         = repmat([1 2 3 4 6 12 -1], length(Frequency), 1);
   if any(prod(a - b , 2))
      Message.identifier = ['finfixed:' Function ':InvalidZeroCurveFrequency'];
      Message.message    =  'Invalid ZeroData rate compounding frequency.';
      return
   end
else
   Frequency = 2;
end

Sigma    = varargin{3}(:);

BondData = varargin{4};
nColumns = size(BondData,2);

if nColumns < 3
   Message.identifier = ['finfixed:' Function ':InvalidBondData'];
   Message.message    =  'BondData matrix must have 3 or 4 columns.';
   return
end

CleanPrice = BondData(:,1);
CouponRate = BondData(:,2);
Maturity   = BondData(:,3);

if nColumns == 4
   Face = BondData(:,4);
else
   Face = 100;
end

Settle = datenum(varargin{5});

if any(Settle ~= Settle(1))
   Message.identifier = ['finfixed:' Function ':InvalidSettlementDate'];
   Message.message    =  'Settle date must be a scalar or array of identical dates.';
   return
end

Settle = Settle(1);   % Guarantee a scalar.

if any(ZeroDates <= Settle)
   Message.identifier = ['finfixed:' Function ':InvalidZeroDates'];
   Message.message    =  'ZeroData dates must occur after option Settle date.';
   return
end

Expiry = datenum(varargin{6});
Expiry = Expiry(:);

if any(Settle > Expiry)
   Message.identifier = ['finfixed:' Function ':InvalidExpiryDate'];
   Message.message    =  'Option Expiry dates must not precede Settle date.';
   return
end

if (numel(Maturity) == 1) || (numel(Expiry) == 1) ...
                          || (length(Maturity) == length(Expiry))
    if any(Maturity < Expiry)
       Message.identifier = ['finfixed:' Function ':InvalidMaturityDate'];
       Message.message    =  'Bonds cannot mature prior to option expiration.';
       return
    end
else
    Message.identifier = ['finfixed:' Function ':InconsistentDimensions'];
    Message.message    =  'Inputs must be scalars or conforming matrices.';
    return
end

if (nInputs < 7) || isempty(varargin{7})
    Period = 2;
else
    Period = varargin{7}(:);
    a      = repmat(Period, 1, 7);
    b      = repmat([0 1 2 3 4 6 12], length(Period), 1);
    if any(prod(a - b , 2))
       Message.identifier = ['finfixed:' Function ':InvalidCouponPeriodicity'];
       Message.message    =  'Invalid bond coupon payment periodicity Period.';
       return
    end
end

if (nInputs < 8) || isempty(varargin{8})
    Basis = 0;
else
    Basis = varargin{8}(:);
	a     = repmat(Basis, 1, 4);
	b     = repmat([0 1 2 3], length(Basis), 1);
	if any(prod(a - b , 2))
       Message.identifier = ['finfixed:' Function ':InvalidBasis'];
       Message.message    =  'Invalid day count Basis.';
       return
    end
end

if (nInputs < 9) || isempty(varargin{9})
    EndMonthRule  = 1;
else
    EndMonthRule = varargin{9}(:);
	a            = repmat(EndMonthRule, 1, 2);
	b            = repmat([0 1], length(EndMonthRule), 1);
	if any(prod(a - b , 2))
       Message.identifier = ['finfixed:' Function ':InvalidEOMRule'];
       Message.message    =  'End-of-month rule must be 0 or 1.';
       return
    end
end

if (nInputs < 10) || isempty(varargin{10})
    method = 'linear';
else
    InterpMethod = varargin{10};
				if numel(InterpMethod) > 1
       Message.identifier = ['finfixed:' Function ':NonScalarInterpMethod'];
       Message.message    =  'Interpolation method must be a scalar.';
       return
    end

    a = repmat(InterpMethod, 1, 3);
    b = repmat([0 1 2], length(InterpMethod), 1);
    if any(prod(a - b , 2))
       Message.identifier = ['finfixed:' Function ':InvalidInterpMethod'];
       Message.message    =  'Interpolation method must be 0, 1, or 2.';
       return
    end
    
    switch InterpMethod
       case 1
          method = 'linear';
       case 2
          method = 'cubic';
       otherwise
          method = 'nearest';
				end
end

if (nInputs < 11) || isempty(varargin{11})
    Convention  = 0;
else
    Convention = varargin{11}(:);
    a          = repmat(Convention, 1, 2);
    b          = repmat([0 1], length(Convention), 1);
    if any(prod(a - b , 2))
       Message.identifier = ['finfixed:' Function ':InvalidStrikeConvention'];
       Message.message    =  'StrikeConvention must be 0 (dirty) or 1 (clean).';
       return
    end
end

%
% Return an empty message structure to indicate no error occurred.
%

Message = Message(zeros(0,1));

Output {1} = Strike;
Output {2} = ZeroDates;
Output {3} = ZeroRates;
Output {4} = Frequency;
Output {5} = Sigma;
Output {6} = CleanPrice;
Output {7} = CouponRate;
Output {8} = Maturity;
Output {9} = Face;
Output{10} = Settle;
Output{11} = Expiry;
Output{12} = Period;
Output{13} = Basis;
Output{14} = EndMonthRule;
Output{15} = method;
Output{16} = Convention;