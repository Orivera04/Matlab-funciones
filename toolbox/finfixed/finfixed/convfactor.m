function CF = convfactor(varargin)
%CONVFACTOR Conversion Factors of U.S. T-Bonds based upon a standard bond.
%   Conversion factors of U.S. T-bonds based on a bond yielding 6%. Optionally, 
%   any type of standard bond can be specified.
%   
%   CF = convfactor(RefDate, Maturity, CouponRate)
%   CF = convfactor(RefDate, Maturity, CouponRate, RefYield) 
%
%   Optional Inputs: RefYield
%
%   Inputs:
%      RefDate - [Nx1] vector of Reference dates, for which conversion factor
%                is to be computed. This is usually the first day of the 
%                delivery month.
%
%     Maturity - [Nx1] vector of maturity dates of the underlying bonds.
%
%   CouponRate - [Nx1] vector of annual coupon rates of the underlying bond 
%                in decimal form.
%
%   Optional Inputs:
%   RefYield - [Nx1] vector of semiannually compounded reference yields.
%              The default is 0.06 (6%).
%
%   Outputs:
%   CF - [Nx1] vector of Conversion Factor against 6% yield par-bond.
%
%   Example:
%   RefDate  = {'1-Dec-2002';
%              '1-Mar-2003';
%              '1-Jun-2003';
%              '1-Sep-2003';
%              '1-Dec-2003';
%              '1-Sep-2003';
%              '1-Dec-2002';
%              '1-Jun-2003'};
% 
%   Maturity = {'15-Nov-2012';
%              '15-Aug-2012';
%              '15-Feb-2012';
%              '15-Feb-2011';
%              '15-Aug-2011';
%              '15-Aug-2010';
%              '15-Aug-2009';
%              '15-Feb-2010'};
% 
%   CouponRate = [0.04; 0.04375; 0.04875; 0.05; 0.05; 0.0575; 0.06; 0.065];
% 
%   CF = convfactor(RefDate, Maturity, CouponRate)
%
%   CF =
%       0.8539
%       0.8858
%       0.9259
%       0.9418
%       0.9403
%       0.9862
%       1.0000
%       1.0266

%   Reference: Krgin, Dragomir, Handbook of Global Fixed Income
%              Calculations, John Wiley & Sons, 2002, pp. 134, 145

% Author: P. Wang
% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.5.6.4 $  $Date: 2004/04/06 01:08:45 $

if nargin < 3
    error('finfixed:convfactor:invalidInput',...
        'Not enough input arguments.')
else
    refDate    = datenum(varargin{1});
    maturity   = datenum(varargin{2});
    couponRate = varargin{3};

    if any(couponRate < 0)
        error('finfixed:convfactor:negativeCouponRate', ...
            'Coupon rates must be positive.')
    end
end

if nargin < 4 || isempty(varargin{4})
    refYield = 0.06;
    
else
    refYield = varargin{4};    
end

% Check/scalar expand inputs
[refDate, maturity, couponRate, refYield] = finargsz(1, refDate(:), ...
    maturity(:), couponRate(:), refYield(:));

% Reference (Settle) must be < maturity
if any(refDate >= maturity)
    error('Finfixed:convfactor:invalidReferenceDate', ...
        'Reference dates must precede maturity dates.')
end

% Constants
FCF = 1; % First Coupon Factor
LCF = 1; % Last Coupon Factor
LDF = 1; % Last Discount Factor

% Get the cash flow dates. We need the first date of each cash flow only.
% T-bond's basis is act/act (0); Period = 2
% CFDATES is defaulted to period = 2 and basis = 0
cflowDates = cfdates(refDate, maturity);

% Determine the number of coupons remaining less 2 for each cashflow.
[y, numCashflows] = max(cflowDates, [], 2);
n = numCashflows - 2;

% Determine the discount factor (DF).
% T-bonds round down to the nearest quarter.
% DF = (compQtr * 3) / 6
%  compQtr = # of months from settle to next coupon date (# of complete
%            quarters)

% Determine how many whole quarters (rounded down) there are between settle
% and next coupon.
compQtr = wholeQtrs(refDate, cflowDates(:,1));

% If DF is 0 (no complete quarters) then decrease n by 1. This means that 
% if any DF(x) <= 0, set DF(x) = 1 and decrease n(x) by 1;
DF = (compQtr * 3) / 6;
zeroDF = (DF <= 0);

DF(zeroDF) = 1;
n(zeroDF) = n(zeroDF) - 1;

% Accrued interest factor: AIF = 1 - DF
AIF = 1 - DF;

% Calculate the conversion factor.
a = (1 + (refYield/2)) .^ (-DF);
b = (couponRate/2) * FCF;
c = (couponRate./refYield) .* (1 - (1 ./ (1 + (refYield/2)).^n));
d = (1 + (couponRate/2)*LCF) .* (1 + (refYield/2)).^(-n-LDF);
e = (couponRate/2) .* AIF;

CF = a .* (b + c + d) - e;


% ---------------------------------------------------
function qtrs = wholeQtrs(settle, nextCoupon)
% Determines the whole quarters between two dates rounding down to the
% nearest quarter. This is specifically designed to conform to CBOT
% practices.
%
% Inputs:
%   date1 : serieal date
%   maturity : serieal date
%
% Outputs: [double]

% Determine the number of bonds. No need to do consistency checks because
% it is already done in finargsz.
numBonds = length(settle);

% Get numeric month #'s
settleMonth = month(settle);
nextCouponMonth = month(nextCoupon);

% Get numeric year #'s
settleyear = year(settle);
nextCouponYear = year(nextCoupon);

qtrs = [];
for idx = 1:numBonds
    if settleMonth(idx) > nextCouponMonth(idx)
        % The settle year is always less than the next coupon year if the
        % settle month is greater than the next coupon month (given that
        % settle month ~= next coupon month).
        % So, to determine the number of quarters do the following:
        % Part 1:
        % Subtract the settle month from 12 to get the remaining months of the
        % settle year. Divide that by 3 and floor the answer. This is the
        % number of whole quarters in the settle year.
        % Part 2:
        % Take the next coupon month divided by 3 and floor the answer. This is
        % the number of whole quarters till the coupon month of the following
        % year.
        % Part 3:
        % Subtract 1 from the diff of the years and multiply the answer by 4.
        % This is the number of quarters in the REMAINING years.
        % Part 4:
        % Add parts 1 through 3
        hold = floor((12 - settleMonth(idx))/3) + floor(nextCouponMonth(idx)/3) + ...
            (nextCouponYear(idx) - settleyear(idx) - 1) * 4;

    elseif settleMonth(idx) < nextCouponMonth(idx)
        % Take the diff of the months and divide it by 3. Then floor the answer.
        % This is the number of whole quarters.
        hold = floor((nextCouponMonth(idx) - settleMonth(idx))/3);

        % Check to see that we are not just finding any 3 consecutive
        % months within a date range and calling it a 'quarter'. 
        % Quarters for t-bonds fall on march, june, sept, and dec. It so happens
        % that if neither the settle month nor the next coupon month fall on
        % march, june, sept, or dec, then we know we are not looking at true 
        % quarters, and thus need to subtract 1.
        %
        %   For example:
        %   settle            = 01/01
        %   next coupon month = 07/01
        %
        %   date1(01/01)
        %     1xxxxxxxxxxxxx7---------: <- 2001
        %                 date2(07/01)
        %
        %   x's show the months within date range. Within this range we need
        %   to determine the whole quarters.
        %
        %   There are 6 months between them (2 'quarters'), but only 1 true
        %   whole quarter.
        nonQtr = [mod(nextCouponMonth(idx), 3),  mod(settleMonth(idx), 3)];
        if all(nonQtr ~= 0)
            hold = hold - 1;
        end

        if settleyear(idx) < nextCouponYear(idx)
            % If the settle year is less than the next coupon year, then
            % just subtract the previously calculated 'hold' (above) from 4.
            % This the number of whole quarters within the first two years. 
            % Next add to that one less of diff of the years times 4.
            %
            %   For example:
            %   settle            = 4/01
            %   next coupon month = 7/03
            %
            %         date1(4/01)
            %     :-----4xxxxxxxxxxxxxxxxxx <- 2001\
            %                                       \ '01/'02 has 4 whole qtrs 
            %     xxxxxxxxxxxxx7----------: <- 2002/
            %                date2(07/03)
            %     :-----------------------: <- 2003 has 4 whole qtrs
            %
            %   x's show the months that need to be used for the whole
            %   quarter calculations. We take the first year to determine the
            %   number of whole quarters. Then we tack on the remaining whole
            %   quarters from the remaining years.
            hold = (4 - hold) + (nextCouponYear(idx) - settleyear(idx) - 1)*4;

        elseif settleyear(idx) > nextCouponYear(idx)
            % This is not possible because settle will always precede the
            % next coupon. This fcn does not specifically check for it but
            % the calling fcn does.
        end

    else
        % If the months are the same.
        % The number of whole quarters is just the diff in years times 4.
        hold = (nextCouponYear(idx) - settleyear(idx)) * 4;

    end

    qtrs = [qtrs; hold];
end


% [EOF]
