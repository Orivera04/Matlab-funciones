function Price = tbillprice(varargin)
%TBILLPRICE Price US Treasury Bills given yields or discount rates.
%   Price T-Bills given yields or discount rates.
%
% Price = tbillprice(Rate, Settle, Maturity)
%
% Price = tbillprice(Rate, Settle, Maturity, Type)
%
% Inputs:
%     Rate     - NTBILL x 1 vector of rates of T-Bills in decimal form. 
%
%     Settle   - NTBILL x 1 vector of dates representing the settlement dates.
%
%     Maturity - NTBILL x 1 vector of dates representing the maturity of T-Bills.
%
% Optional Inputs:
%     Type     - NTBILL x 1 vector of Rate Type. Use this vector to define
%                how to interpret the values entered in the vector Rate. 
%                Enter (1) for Money Market Yield, (2) for 
%                Bond-Equivalent Yield, or (3) for Discount rate.
%                Default is Money Market Yield.
%
% Outputs:
%      Price   - NTBILL x 1 vector of prices of the T-Bills for every $100 face.
%
%
% Note: The Money Market Yield basis is actual/360.
%       The Bond-Equivalent Yield basis is actual/365.
%       The Discount Rate basis is actual/360.
%
% Example:
% Rate = 0.0150;
% Settle = '28-Nov-2002';
% Maturity = '27-Feb-2003';
% Type = 3;
% 
% Price = tbillprice(Rate, Settle, Maturity, Type) returns
%
%         Price =  99.62
%
% See also TBILLDISC2YIELD, TBILLYIELD2DISC, TBILLYIELD.
%
% References: 
%             SIA Fixed Income Securities Formulas for Price, Yield, and
%             Accrued Interest, Volume 1.
%             Stigum & Robinson: Money Market & Bond Calulations.
%             Dragomir Krgin: Handbook of Global Fixed Income Calculations.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.3 $   $Date: 2004/04/06 01:09:08 $

%-------------------------------------------
% Input arguments check
%-------------------------------------------
if (nargin <3 | nargin>4)
  error('finfixed:tbillprice:invalidInput',['Incorrect number of inputs. ', ...
         'Please type "help tbillprice" for more information'])
end

[Rate, Settle, Maturity] = finargparse({'dble';'date';'date'}, varargin{1:3});


% Set default type to 1 (Money Market Yield)
if nargin < 4 | isempty(varargin{4})
    Type = 1;    
else
    Type = varargin{4};     
    
    if any(Type ~=1  & Type ~= 2 & Type ~= 3)
      error ('finfixed:tbillprice:invalidType',['Type must be either 1 (Money Market Yield), ', ... 
              '2 (Bond-Equivalent Yield), or 3 (Discount Rate)'])
    end
end

% Verify that we have vectors
if( numel(Rate) ~= length(Rate) | numel(Settle) ~= length(Settle) | ...
        numel(Maturity) ~= length(Maturity) | numel(Type) ~= length(Type) )
    error('finfixed:tbillprice:invalidInput', 'Rate, Settle, Maturity, and Type must be vectors')
end

Rate = Rate(:); Settle = Settle(:); Maturity = Maturity(:); Type = Type(:);

% Size expansion
[Rate, Settle, Maturity, Type] = finargsz(1, Rate, Settle, Maturity, Type);

% find out where rate is not that of Discount
idx12 = find(Type == 1 | Type == 2);

NTBILL = length(Settle); 

Price = zeros(NTBILL,1);
DSM = zeros(NTBILL,1);

% Calculate Price of T-bill.
% First convert the MMYield and BEYield to Discount Rate
if ~isempty(idx12)
  Rate(idx12) = tbillyield2disc(Rate(idx12),Settle(idx12),Maturity(idx12),Type(idx12));
end

% And compute the the Price of T-bill now that we have all 
% annualized discount rate.
Face = 100;
DSM = daysact(Settle, Maturity);
Price = Face - (Rate.*Face.*DSM./360);

