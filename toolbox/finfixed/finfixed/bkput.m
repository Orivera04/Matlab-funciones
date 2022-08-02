function PutPrices = bkput(varargin)
%BKPUT Black's model for pricing European put options on bonds.
%   Compute the prices of NOPTIONS European put options on bonds using 
%   Black's model.
%
%   PutPrice = bkput(Strike, ZeroData, Sigma, BondData, Settle, Expiry)
%   PutPrice = bkput(Strike, ZeroData, Sigma, BondData, Settle, Expiry,
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
%   PutPrice - NOPTIONS x 1 vector of prices of European put options on 
%     bonds derived from Black's model.
%
% Note:
%   In the event cash flows occur beyond the dates spanned by the input zero
%   curve ZeroData, the appropriate zero rate for discounting such cash flows
%   is obtained by simply extrapolating the nearest rate on the curve. In
%   other words, if a cash flow occurs before the first or after the last 
%   date found on the input zero curve, a flat zero curve is assumed.
%
% See also BKCALL, BLKPRICE, INTERP1.

%   Author(s): K. Lui 1/2004
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.9.6.5 $  $Date: 2004/04/06 01:08:40 $

%
% Implement BKPUT as a pure wrapper around BKCALL.
%

try
  [CallPrices, PutPrices] = bkcall(varargin);
catch
  errorStruct            = lasterror;
  errorStruct.identifier = strrep(errorStruct.identifier, 'bkcall', 'bkput');
  errorStruct.message    = strrep(errorStruct.message   , 'bkcall', 'bkput');
  rethrow(errorStruct);
end