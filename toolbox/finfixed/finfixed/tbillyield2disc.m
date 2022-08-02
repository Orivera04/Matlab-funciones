function Discount = tbillyield2disc(varargin)
%TBILLYIELD2DISC Discount rates of T-Bills from yields.
%   Converts T-Bill yields into discount rates.
%
% Discount = tbillyield2disc(Yield, Settle, Maturity)
%
% Discount = tbillyield2disc(Yield, Settle, Maturity, Type)
%
% Inputs:
%     Yield    - NTBILL x 1 vector of yields of T-Bills in decimal form.
%
%     Settle   - NTBILL x 1 vector of dates representing the settlement dates.
%
%     Maturity - NTBILL x 1 vector of dates representing the maturity of T-Bills.
%
% Optional Inputs:
%     Type     - NTBILLx1 vector of Yield Type. Use this vector to define
%                how to interpret the values entered in the vector Yield.
%                Enter (1) for Money Market Yield, or (2) for
%                Bond-Equivalent Yield. Default is Money Market Yield.
%
% Outputs:
%    Discount - NTBILL x 1 vector of discount rates of the T-Bills.
%
%
% Note: The Money Market Yield basis is actual/360.
%       The Bond-Equivalent Yield basis is actual/365.
%       The Discount Rate basis is actual/360.
%
% Example:
% Yield  = 0.0151;
% Settle = '28-Nov-2002';
% Maturity = '27-Feb-2003';
%
% Discount = tbillyield2disc(Yield, Settle, Maturity)
%
%        returns Discount = 0.01504
%
% See also TBILLDISC2YIELD, TBILLPRICE, TBILLYIELD.
%
% References: Stigum & Robinson: Money Market & Bond Calulations.
%             Dragomir Krgin: Handbook of Global Fixed Income Calculations.

%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.5.6.3 $   $Date: 2004/04/06 01:09:12 $

%-----------------------------------------------------------------
% Checking Inputs
%-----------------------------------------------------------------
if (nargin >4 | nargin < 3)
    error('finfixed:tbillyield2disc:invalidInput',['Incorrect number of inputs. ',...
        'Please type "help tbillyield2disc" for more information'])
end

[Yield, Settle, Maturity] = finargparse({'dble';'date';'date'}, varargin{1:3});


% Set default type to 1 (Money Market Yield)
if nargin < 4 | isempty(varargin{4})
    Type = 1;
else
    Type = varargin{4};

    if any(Type ~=1  & Type ~= 2)
        error ('finfixed:tbillyield2disc:invalidType',['Type must be either 1 (Money Market Yield) ', ...
            'or 2 (Bond-Equivalent Yield)'])
    end
end

% Verify that we have vectors
if( numel(Yield) ~= length(Yield) | numel(Settle) ~= length(Settle) | ...
        numel(Maturity) ~= length(Maturity) | numel(Type) ~= length(Type) )
    error('finfixed:tbillyield2disc:invalidInput', 'Yield, Settle, Maturity, and Type must be vectors')
end

Yield = Yield(:); Settle = Settle(:); Maturity = Maturity(:); Type = Type(:);

% Size expansion
[Yield, Settle, Maturity, Type] = finargsz(1, Yield, Settle, Maturity, Type);


if any(Settle > Maturity)
    error('finfixed:tbillyield2disc:invalidSettleDate','Settle must be less than or equal to Maturity')
end

% Find "short" and "long" bills
% Short Bill=> ones with maturity shorter/equal-to a 182 days
% Long Bill=> ones with maturity longer than 182 day,

NZEROS = length(Settle);

% Calculate the Discount Rate based on the Type of Yield entered.
% Discount of T-Bills are calculated as if a year had 360 days.
% Discount  = 360 * BEY/ (365 + BEY * DSM)   for BEY
% Discount  = 360 * MMY/ (360 + MMY * DSM)   for MMY

A = zeros(NZEROS,1);
Discount = A;

Type1Mask = (Type==1);
A(Type1Mask) = 360; % US Money-market Yield basis
A(~Type1Mask) = 365; % US Bond Equivalent Yield basis

DSM = daysact(Settle,Maturity); % days between settle and maturity

idxShort = find(DSM <=182); %maturity < 182 days
idxLong = find(DSM >182);  %maturity > 182 days

% Short T-bills(maturity < 182 days)
if ~isempty(idxShort)

    Discount(idxShort) = 360./DSM(idxShort).*(1-(1./ ...
        (1 + Yield(idxShort) .* DSM(idxShort)./A(idxShort))));
end

% Long T-bills
if ~isempty(idxLong)

    Discount(idxLong) = 360./DSM(idxLong).*(1-(1./ ...
        (((1 + Yield(idxLong)/2)) .* (1 +(2.*DSM(idxLong)./A(idxLong)-1).*Yield(idxLong)/2))));
 end

if any(Discount < 0)
    warning('finfixed:tbillyield2disc:negativeDiscount',['One of the results is Negative. ', ...
        'Consider checking the input arguments again'])
end
