function [MMYield, BEYield, Discount] = tbillyield(Price, Settle, Maturity)
%TBILLYIELD Yields of US Treasury bills given Price. 
%   Calculates money market yields, bond-equivalent yields or discount rates
%   given prices of T-Bills.
%
% [MMYield, BEYield, Discount] = tbillyield(Price, Settle, Maturity)
%
% Inputs:
%   Price    - NTBILL x 1 vector of prices of T-Bills for every $100 face
%              value.
%
%   Settle   - NTBILL x 1 vector of dates representing the settlement dates.
%
%   Maturity - NTBILL x 1 vector of dates representing the maturity of T-Bills.
%         
% Outputs:
%   MMYield  - NTBILL x 1 vector of Money Market Yields. 
%
%   BEYield  - NTBILL x 1 vector of Bond-Equivalent Yields.
%
%   Discount - NTBILL x 1 vector of discount rates of the T-Bills.
%
%
% Note: The Money Market Yield basis is actual/360.
%       The Bond-Equivalent Yield basis is actual/365.
%       The Discount Rate basis is actual/360.
%
% Example:
% Price  = 99.62;
% Settle = '28-Nov-2002';
% Maturity = '27-Feb-2003';
%
% [MMYield, BEYield, Discount] = tbillyield(Price, Settle, Maturity)
%
%      returns   MMYield =0.0151, BEYield = 0.0153 and  Discount=0.0150
%
% See also TBILLDISC2YIELD, TBILLYIELD2DISC, TBILLPRICE.
%
% References: 
%             SIA Fixed Income Securities Formulas for Price, Yield, and
%             Accrued Interest, Volume 1.
%             Stigum & Robinson: Money Market & Bond Calulations.
%             Dragomir Krgin: Handbook of Global Fixed Income Calculations.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.7.6.3 $   $Date: 2004/04/06 01:09:11 $

%-------------------------------------------
% Input arguments check
%-------------------------------------------
if (nargin ~= 3)
    error('finfixed:tbillyield:invalidInput',['Incorrect number of inputs. ', ...
        'Please type "help tbillyield" for more information'])
end

[Price, Settle, Maturity] = finargparse({'dble';'date';'date'}, Price, Settle, Maturity);

% Verify that we have vectors
if( numel(Price) ~= length(Price) | numel(Settle) ~= length(Settle) | ...
        numel(Maturity) ~= length(Maturity))
    error('finfixed:tbillyield:invalidInput', 'Price, Settle, and Maturity must be vectors')
end

Price = Price(:); Settle = Settle(:); Maturity = Maturity(:);

% Size expansion
[Price, Settle, Maturity] = finargsz(1, Price, Settle, Maturity);

if any(Settle > Maturity)
    error('finfixed:tbillyield:invalidSettleDate','Settle must be less than or equal to Maturity')
end

% Compute the the Price of T-bill based on the
% rates given/computed.
DSM = daysact(Settle, Maturity);

idxShort = find(DSM <= 182); % "short" bill
idxLong = find(DSM > 182); % "long" bill

% MMYield and Discount use same formula for both short and long bills. The 
% MMYield and Discount are calculated in terms of Prices.
MMYield = (100./Price - 1)*360./DSM;
Discount = (1 - Price/100)*360./DSM; 

% short T-Bills
if ~isempty(idxShort)
    BEYield(idxShort) = MMYield(idxShort)*365/360;    
end

% long T-Bills
if ~isempty(idxLong)
    X = DSM(idxLong)/365;
    BEYield(idxLong) = (-2*X + 2*sqrt( X.^2 -(2*X - 1).*(1 - 100./Price(idxLong)))) ./ ...
        (2*X - 1);
end

varargout{1} = MMYield;
varargout{2} = BEYield;
varargout{3} = Discount;
