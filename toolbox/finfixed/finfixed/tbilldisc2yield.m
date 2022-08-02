function [BEyield, MMyield] = tbilldisc2yield(Disc, Settle, Maturity)
%TBILLDISC2YIELD T-Bills discount rate to yields.
%   Converts discount rates to bond-equivalent yields or money market yields.
%
% [BEYield, MMYield] = tbilldisc2yield(Discount, Settle, Maturity)
%
% Inputs:
%   Discount - NTBILL X 1 vector of discount rates of T-Bills, in decimal.
%
%   Settle   - NTBILL x 1 vector of dates representing the settlement dates.
%
%   Maturity - NTBILL x 1 vector of dates representing the maturity of T-Bills.
%
% Outputs:
%   BEYield  - NTBILL x 1 vector of Bond Equivalent Yields.
%
%   MMYield  - NTBILL x 1 vector of Money Market Yields. 
%
%
% Note: The Money Market Yield basis is actual/360.
%       The Bond-Equivalent Yield basis is actual/365.
%       The Discount Rate basis is actual/360.
%
% Example:
% Discount = 0.01504;
% Settle   = '28-Nov-2002';
% Maturity = '27-Feb-2003';
%
% [BEYield, MMYield] = tbilldisc2yield(Discount, Settle, Maturity)
%
%        returns BEYield = 0.0153   and   MMYield = 0.0151
%
%
% See also TBILLDISC2YIELD, TBILLPRICE, TBILLYIELD.
%
% References: Stigum & Robinson: Money Market & Bond Calulations.
%             Dragomir Krgin: Handbook of Global Fixed Income Calculations.

%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.5.6.3 $   $Date: 2004/04/06 21:52:53 $

%-----------------------------------------------------------------
% Checking Inputs
%-----------------------------------------------------------------

if nargin ~=3
  error('finfixed:tbilldisc2yield:invalidInput',['Incorrect number of inputs. ', ...
        'Please type "help tbilldisc2yield" for more information'])
end

[Disc, Settle, Maturity] = finargparse({'dble';'date';'date'}, Disc, Settle, Maturity);

% Verify that we have vectors
if( numel(Disc) ~= length(Disc) | numel(Settle) ~= length(Settle) | ...
        numel(Maturity) ~= length(Maturity))
    error('finfixed:tbilldisc2yield:invalidInput', 'Disc, Settle, and Maturity must be vectors')
end

Disc = Disc(:); Settle = Settle(:); Maturity = Maturity(:);

% size expansion
[Disc, Settle, Maturity] = finargsz(1, Disc, Settle, Maturity);

if any(Settle > Maturity)
    error('finfixed:tbilldisc2yield:invalidSettleDate','Settle must be less than or equal to Maturity')
end

% find "short" and "long" bills, ones with maturity shorter/equal to 
% and longer than 182 days, respectively on 365 day basis
DSM = daysact(Settle, Maturity); 
idxShort = find(DSM <= 182);
idxLong = find(DSM > 182);

% Initialize variables
NTBills = length(Disc);
MMyield = nan * ones(NTBills,1);
BEyield = MMyield;

% Short T-Bills 
if ~isempty(idxShort)
    MMyield(idxShort) = 360*Disc(idxShort) ./ (360 - Disc(idxShort).*DSM(idxShort));
    BEyield(idxShort) = MMyield(idxShort) * 365/360; % or BEY=365*d/(360-Disc*DSM)

end

% Long T-Bills - all qty are annualized 
if ~isempty(idxLong)
    Price = 100*(1 - Disc(idxLong) .* DSM(idxLong)/360);  % original    
    MMyield(idxLong) = ((100 ./ Price)-1) .* (360 ./ DSM(idxLong));
        
    X = DSM(idxLong)/365;
    BEyield = (-2*X + 2*sqrt( X.^2 - (2*X - 1).*(1 - 100./Price) ) ) ./ ...
        (2*X - 1);
    
end

if any(BEyield < 0)
  warning('finfixed:tbilldisc2yield:negativeBondYield',['One of the results is negative. ', ...
           'Consider checking the input arguments again'])
end
