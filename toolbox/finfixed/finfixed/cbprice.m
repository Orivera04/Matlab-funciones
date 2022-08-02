function [cb_matrix, und_matrix, debt_matrix, eqty_matrix] = ...
    cbprice(varargin)
%CBPRICE Convertible bond prices with one-factor lattice method.
%   Trees of Convertible prices, underlying, debt,
%   and equity portions.
%
% CbMatrix = cbprice(RiskFreeRate, StaticSpread, Sigma, Price, ...
%   ConvRatio, NumSteps, IssueDate, Settle, Maturity, ...
%     CouponRate)
%
% [CbMatrix, UndMatrix, DebtMatrix, EqtyMatrix]  = ...
%   cbprice(RiskFreeRate, StaticSpread, Sigma, Price, ...
%     ConvRatio, NumSteps, IssueDate, Settle, Maturity, ...
%       CouponRate, Period, Basis, EndMonthRule, DividendType, ...
%          DividendInfo, CallType, CallInfo, TreeType)
%
% Inputs (All scalar values):
%   RiskFreeRate - Scalar value of risk-free rate in decimal.
%                  Rate is annualized and continuously compounded.
%                  (Recommended value is yield of risk free bond
%                  with the same maturity of the convertible).
%
%   StaticSpread - Scalar value of constant spread to risk free rate.
%                  Adding this to RiskFreeRate will produce
%                  the issuer's yield, which reflects its credit
%                  risk.
%
%          Sigma - Scalar value of annual volatility
%                  environment in decimal.
%
%          Price - Scalar value of price of asset at
%                  Settle.
%
%      ConvRatio - Scalar value of number of assets
%                  convertible to one bond.
%
%       NumSteps - Scalar value of number of steps
%                  within binomial tree.
%
%      IssueDate - Scalar value of Issue date of
%                  convertible bond.
%
%         Settle - Scalar value of Settlement date
%                  of convertible bond.
%
%       Maturity - Scalar value of Maturity date
%                  of convertible bond.
%
%     CouponRate - Scalar value of Coupon-rate
%                  in decimal.
%
% Optional Inputs:
%         Period - Scalar value for number of coupon payments
%                    1 - one coupon per year
%                    2 - semi annual     (default)
%                    3 - three times a year
%                    4 - quarterly
%                    6 - bi-monthly compounding
%                   12 - monthly
%
%          Basis - Scalar value for accrual basis of bond.
%                    0 - actual/actual   (default)
%                    1 - 30/360 (SIA compliant)
%                    2 - actual/360
%                    3 - actual/365
%
%   EndMonthRule - Scalar value specifying whether or no
%                  the "end of month rule" is in effect for
%                  each bond contained in the portfolio.
%                  1 - on (default)
%                  0 - off
%
%   DividendType - Scalar value. Divident Type
%                  0 - dollar dividend (default)
%                  1 - dividend yield.
%
%   DividendInfo - Two-column matrix of dividend information.
%                  First Column is the ex-dividend date corresponding
%                  to the amount in the Second column. Enter any amount
%                  known at any time; We will use one(s) within the
%                  lifespan of the option.
%                  Default is no dividend.
%
%       CallType - Scalar value for call type.
%                  0 - call on Cash price (default)
%                  1 - call on Clean price.
%
%       CallInfo - Two-column matrix containing call information.
%                  First Column is the call dates, and the second
%                  is the call prices for every $100 face of bond.
%                  Call in the amount of call prices is activated
%                  AFTER the corresponding call date.
%                  Default is no call feature.
%
%       TreeType - Scalar value for tree type
%                  0 - binomial lattice (default).
%                  1 - trinomial lattice.
%
% Outputs:
%       CbMatrix - Matrix of CB prices in binomial format.
%                  Price of Convertible is CbMatrix(1,1)
%      UndMatrix - Matrix of Stock prices in binomial format.
%     DebtMatrix - Matrix of CB debt component in binomial format.
%     EqtyMatrix - Matrix of CB equity component in binomial format.
%
% Example :
% % Spread effect analysis of 4% coupon callable at 110 at end of
% % second year,  maturing par in five years, and YTM of 5% with
% % spread (of YTM vs 5 year treasury) of 0, 50, 100, and 150 bp.%
% % Further, the stock pays no dividend.
%
%   clear all; clc;
%   RiskFreeRate = 0.05;
%   Sigma        = 0.3;
%   ConvRatio    = 1;
%   NumSteps     = 200;
%   IssueDate    = datenum('2-Jan-2002');
%   Settle       = datenum('2-Jan-2002');
%   Maturity     = datenum('2-Jan-2007');
%   CouponRate   = 0.04;
%   Period       = 2;
%   Basis        = 1;
%   EndMonthRule = 1;
%   DividendType = 0;
%   DividendInfo = [];
%   CallInfo     = [datenum('2-Jan-2004') , 110];
%   CallType     = 1;
%   TreeType     = 1;
%
%   % Nested loop across Prices and StaticSpread dimensions
%   % to compute Convertible prices
%
%   for j = 0:0.005:0.015;
%       StaticSpread = j;
%       for i = 0:10:100
%         Price = 40+i;
%         [CbMatrix, UndMatrix, DebtMatrix, EqtyMatrix] = ...
%           cbprice(RiskFreeRate, StaticSpread, Sigma, Price, ...
%             ConvRatio, NumSteps, IssueDate, Settle, ...
%               Maturity, CouponRate, Period, Basis, EndMonthRule, ...
%                 DividendType, DividendInfo, CallType, CallInfo, TreeType);
%
%           convprice(i/10+1,j*200+1) = CbMatrix(1,1);
%           stock(i/10+1,j*200+1)     = Price;
%       end
%   end
%
%   plot(stock,convprice);
%   legend({'+0 bp'; '+50 bp'; '+100 bp'; '+150 bp'});
%   title ('Effect of Spread using Trinomial tree - 200 steps')
%   xlabel('Stock Price');
%   ylabel('Convertible Price');
%   text(50, 150, ['Coupon 4 semiannual,', sprintf('\n'), ...
%        '110 Call-on-clean after 2 years,' sprintf('\n'), ...
%        'maturing par in 5 years'],'fontweight','Bold')

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.7.6.4 $   $Date: 2004/04/06 01:08:41 $

if nargin < 10
    error('finfixed:cbprice:invalidInputs',...
        ['Need RiskFreeRate, StaticSpread, Sigma, Strike, ', ...
        'Price, ConvRatio, NumSteps, IssueDate, Settle, ', ...
        'and Maturity']);
end

rate        = varargin{1};
spread      = varargin{2};
Sigma       = varargin{3};
So          = varargin{4};
convratio   = varargin{5};
numbersteps = varargin{6};
issuedate   = datenum(varargin{7});
settle      = datenum(varargin{8});
maturity    = datenum(varargin{9});
couponrate  = varargin{10};

if nargin < 11 || isempty(varargin{11})
    period = 2;
else
    period = floor(varargin{11});
    if period == 0
        if (couponrate ~= 0)
            error('finfixed:cbprice:invalidPeriod',...
                'Zero-Coupon cannot have any coupon.');
        else
            period = 1;
        end
    end
end

if nargin < 12 || isempty(varargin{12})
    basis = 0;
else
    basis = varargin{12};
    if any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)
        error('finfixed:cbprice:invalidbasis','Invalid day count basis.');
    end
end

if nargin < 13 || isempty(varargin{13})
    eom = 1;
else
    eom = floor(varargin{13});
    if (eom~=0 && eom~=1)
        error('finfixed:cbprice:invalidEOM',...
            'EndMonthRule must be 0 or 1.');
    end
end

if nargin < 14 || isempty(varargin{14})
    dividend_type = 0;
else
    dividend_type = floor(varargin{14});
    if (dividend_type~=0 && dividend_type~=1)
        error('finfixed:cbprice:invaliddivtype',...
            'DividendType must be 0 or 1.');
    end
end

if nargin < 15 || isempty(varargin{15})
    dividend_info = [settle 0];
else
    % parse and sort dividend data
    dividend_info = varargin{15};
    [exdivdate m dummy] = unique(datenum(dividend_info(:,1)));
end

if nargin < 16 || isempty(varargin{16})
    call_type = 0;
else
    call_type = varargin{16};
    if (call_type~=0 && call_type~=1)
        error('finfixed:cbprice:invalidcalltype',...
            'CallType must be 0 or 1.');
    end
end

if nargin < 17 || isempty(varargin{17})
    callamount = inf;
    calldate = settle;
else
    call_info = varargin{17};
    [calldate m dummy] = unique(datenum(call_info(:,1)));
    callamount = call_info(:,2);
    callamount = callamount(m);

    % get only call within the life of option
    affecting_idx = find(calldate >= issuedate &  calldate <= maturity);
    if ~isempty(affecting_idx)
        callamount = callamount(affecting_idx);
        calldate = calldate(affecting_idx);
        % if there is at least one calldate prior to settlement and
        % it applies through at least one period after settlement,
        % we will artificially create a call schedule at settle with
        % value of call the same as one immediately prior to it
        if any(calldate <= settle)
            callamount = unique([callamount(max(find(calldate<=settle))); ...
                callamount(calldate>=settle)]);
            calldate   = unique([settle; calldate(calldate>=settle)]);
        end
    else % there is no calldate active within the life of option
        callamount = inf;
        calldate = settle;
    end
end

if nargin < 18 || isempty(varargin{18})
    tree_type = 0;
else
    tree_type = varargin{16};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                               %
%  Create binomial tree for underlying (Stock)  %
%                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dates for coupons coming in from the future
coupondates = ...
    cfdates(settle, maturity, period, basis, eom, issuedate);

% time to coupons coming in from the future
% time2cpn =  (coupondates - settle) / 365.25;
time2cpn = yearfrac(settle,coupondates,basis);

% get the time to maturity
% time = (maturity - settle) / 365.25;
time = yearfrac(settle,maturity,basis);

dt = time/numbersteps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%      Create Coupon Matrix         %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% which time steps immediately BEFORE coupons?
idx2cpn = time2cpn/dt + 1;
couponpv = zeros(1,numbersteps+1);

% large time steps will have more than one coupon in it,
% so add them up.
flooridxcpn = floor(idx2cpn);
[uniqueidx, I, InstOrder] = unique(flooridxcpn);
NumPoints = length(uniqueidx);
[JPoint, InstOrder] = ndgrid(1:NumPoints, InstOrder);
CpnMap = (JPoint == InstOrder);

% calculate the coupons
dummycouponpv = 100*couponrate/period*...
    exp(-(rate+spread)*dt*(idx2cpn-flooridxcpn));

% now assign them to their respective locations.
% the multiplications simply adds PV of two coupons within
% the same time step.
couponpv(uniqueidx) = dummycouponpv * CpnMap';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%        Create Call Matrix         %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time to call dates
% time2call = (calldate - settle)' / 365.25;
time2call = yearfrac(settle, calldate, basis)';

% which call should be applied to each time step?
idx2call = ceil(time2call/dt) + 1;

% initiate call matrix
callmatrix = zeros(1,numbersteps+1);

if idx2call(1) ~=1
    callmatrix(1:idx2call(1)-1) = inf;
end

for i = 1:length(idx2call)-1
    callmatrix(idx2call(i):idx2call(i+1)-1) = callamount(i);
end

% the only exception where call dates would precisely
% end on node is at Maturity, and it is equal to
% whatever last call amount was agreed upon.
callmatrix(idx2call(end):end) = callamount(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                      %
% Adjustment to the Call Matrix when Strike-on-Clean   %
% price is specified                                   %
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if call_type
    % best AI approximation for continous time is round.
    nodedates = round(linspace(settle, maturity, numbersteps+1));

    % accrfrac to determine fractional period given basis
    ai_frac = accrfrac(nodedates, maturity, period, ...
        basis, eom, issuedate);

    callmatrix = callmatrix + 100*ai_frac'*couponrate/period;
end

switch tree_type

    case 0 % binomial
        [und_matrix, pu, pd] = crrbintree(So, Sigma, rate, settle, ...
            maturity, numbersteps, dividend_type, dividend_info, basis);

        if any(und_matrix < 0)
            error('finfixed:cbprice:negativeBinTreeMatrix','Negative underlying price detected')
        end

        callmatrix   = callmatrix(ones(1,numbersteps+1),:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                    %
        %        Value the end nodes         %
        %                                    %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        idxdebt = ...
            find(convratio*und_matrix(:,end) < 100*(1+couponrate/period) );
        idxeqty = setdiff(1:numbersteps+1, idxdebt);

        debt_matrix = und_matrix*0;
        debt_matrix(idxdebt,end) = 100*(1+couponrate/period);

        eqty_matrix = und_matrix*0;
        eqty_matrix(idxeqty,end) = convratio*und_matrix(idxeqty,end);

        cb_matrix = und_matrix*0;
        cb_matrix(:,end) = eqty_matrix(:,end) + debt_matrix(:,end);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                          %
        %     Work back the nodes using            %
        %     the following logic:                 %
        %                                          %
        %  1. Calculate rollback value using risk  %
        %     neutral probability, for debt and    %
        %     equity component.                    %
        %     Debt is discounted at (R+Spread)     %
        %     while Equity is discounted at R      %
        %                                          %
        %  2. See if this value is HIGHER than     %
        %     both N*Stockprice AND CallPrice.     %
        %     If that happens, the issuer can      %
        %     force conversion to the user and set %
        %     node prices to N*Stockprices.        %
        %                                          %
        %  3. If the rollback value is less than   %
        %     N*Stockprice, then holder will       %
        %     convert voluntarily. Set node prices %
        %     to N*Stockprice.                     %
        %                                          %
        %  4. Otherwise, it is the rollback value  %
        %     computed in Step 1 above.            %
        %                                          %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for n = numbersteps:-1:1

            % calculate rollback values
            eqty_matrix(1:n,n) = ...
                (pu*eqty_matrix(1:n,n+1)+ pd*eqty_matrix(2:n+1,n+1))*...
                exp(-rate*dt);

            debt_matrix(1:n,n) = ...
                (pu*debt_matrix(1:n,n+1) + pd*debt_matrix(2:n+1,n+1))*...
                exp(-(rate+spread)*dt) + couponpv(n);

            cb_matrix(1:n,n) = debt_matrix(1:n,n) + eqty_matrix(1:n,n);

            % When Intrinsic > N*Stock > Call
            % then forced conversion will be made
            idxforceconv = ...
                find( (cb_matrix(1:n,n) > convratio*und_matrix(1:n,n)) & ...
                (convratio*und_matrix(1:n,n) > callmatrix(1:n,n)) );
            eqty_matrix(idxforceconv,n) = convratio*und_matrix(idxforceconv,n);
            debt_matrix(idxforceconv,n) = 0;

            % When Intrinsic < N*Stock
            % then voluntary conversion will be made
            idxfreeconv = ...
                find( cb_matrix(1:n,n) < convratio*und_matrix(1:n,n) );
            eqty_matrix(idxfreeconv,n) = convratio*und_matrix(idxfreeconv,n);
            debt_matrix(idxfreeconv,n) = 0;

            % The rest requires no change in intrinsic value
            % re-update cb_matrix before moving to earlier column
            cb_matrix(1:n,n) = debt_matrix(1:n,n) + eqty_matrix(1:n,n);

        end

    case 1 % trinomial

        [und_matrix, pu, pm, pd] = crrtritree(So, Sigma, rate, settle, ...
            maturity, numbersteps, dividend_type, dividend_info,basis);

        if any(und_matrix < 0)
            error('finfixed:cbprice:negativeTriTreeMatrix','Negative underlying price detected')
        end

        callmatrix   = callmatrix(ones(1,2*numbersteps+1),:);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                    %
        %        Value the end nodes         %
        %                                    %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        idxdebt = ...
            find(convratio*und_matrix(:,end) < 100*(1+couponrate/period) );
        idxeqty = setdiff(1:(2*numbersteps+1), idxdebt);

        debt_matrix = und_matrix*0;
        debt_matrix(idxdebt,end) = 100*(1+couponrate/period);

        eqty_matrix = und_matrix*0;
        eqty_matrix(idxeqty,end) = convratio*und_matrix(idxeqty,end);

        cb_matrix = und_matrix*0;
        cb_matrix(:,end) = eqty_matrix(:,end) + debt_matrix(:,end);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                          %
        %     Work back the nodes using            %
        %     the following logic:                 %
        %                                          %
        %  1. Calculate rollback value using risk  %
        %     neutral probability, for debt and    %
        %     equity component.                    %
        %     Debt is discounted at (R+Spread)     %
        %     while Equity is discounted at R      %
        %                                          %
        %  2. See if this value is HIGHER than     %
        %     both N*Stockprice AND CallPrice.     %
        %     If that happens, the issuer can      %
        %     force conversion to the user and set %
        %     node prices to N*Stockprices.        %
        %                                          %
        %  3. If the rollback value is less than   %
        %     N*Stockprice, then holder will       %
        %     convert voluntarily. Set node prices %
        %     to N*Stockprice.                     %
        %                                          %
        %  4. Otherwise, it is the rollback value  %
        %     computed in Step 1 above.            %
        %                                          %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for n = numbersteps:-1:1

            % calculate rollback (or intrinsic) values
            eqty_matrix(1:(2*n-1),n) = exp(-rate*dt) * ...
                (pu*eqty_matrix(1:(2*n-1), n+1)  + ...
                pm*eqty_matrix(2:2*n,  n+1)  + ...
                pd*eqty_matrix(3:(2*n+1), n+1));

            debt_matrix(1:(2*n-1),n) = exp(-(rate+spread)*dt) * ...
                (pu*debt_matrix(1:(2*n-1), n+1) + ...
                pm*debt_matrix(2:2*n,  n+1) + ...
                pd*debt_matrix(3:(2*n+1), n+1)) + ...
                couponpv(n);

            cb_matrix(1:(2*n-1),n) = ...
                debt_matrix(1:(2*n-1),n) + eqty_matrix(1:(2*n-1),n);

            % When Intrinsic > N*Stock > Call
            % then forced conversion will be made
            idxforceconv = ...
                find( (cb_matrix(1:(2*n-1),n) > convratio*und_matrix(1:(2*n-1),n)) & ...
                (convratio*und_matrix(1:(2*n-1),n) > callmatrix(1:(2*n-1),n)) );
            eqty_matrix(idxforceconv,n) = convratio*und_matrix(idxforceconv,n);
            debt_matrix(idxforceconv,n) = 0;

            % When Intrinsic < N*Stock
            % then voluntary conversion will be made
            idxfreeconv = ...
                find( cb_matrix(1:(2*n-1),n) < convratio*und_matrix(1:(2*n-1),n) );
            eqty_matrix(idxfreeconv,n) = convratio*und_matrix(idxfreeconv,n);
            debt_matrix(idxfreeconv,n) = 0;

            % The rest requires no change in intrinsic value:
            % re-update cb_matrix before moving to "earlier" column
            cb_matrix(1:(2*n-1),n) = ...
                debt_matrix(1:(2*n-1),n) + eqty_matrix(1:(2*n-1),n);

        end

end

function [und_matrix, pu, pd] = crrbintree(price, Sigma, Rf, ...
    settle, maturity, numbersteps, varargin)
% CRRBINTREE : Binomial tree consistent with
%              with geometric Brownian motion.
%
%              dS = mu*S*dt + Sigma*S*dz
%
% [tree, pu, pd] = crrbintree(So, Sigma, Rf, BeginDates, ...
%     EndDates, numstep, dividend_type, dividend_info)
%
% Inputs:
%
% So             - [SCALAR]
%                  Current stock price
%                  Example: 100
%
% Sigma          - [SCALAR]
%                  Annual Volatility in decimal
%                  Example: 0.25 (25%)
%
% Rf             - [SCALAR]
%                  Risk-free rate in decimal, suggested value is
%                  zero-rate treasury with same length
%                  to Maturity.
%                  Example: 0.05 (5%)
%
% BeginDates     - [SCALAR]
%                  Dates corresponding to tree apex.
%                  Example: datenum('20-Dec-2002')
%
% EndDates       - [SCALAR]
%                  Dates corresponding to last column in tree
%                  Example: datenum('20-Dec-2003')
%
% NumStep        - [SCALAR]
%                  Number of time step between Begin- to End-
%                  Dates.
%                  Example: 150
%
% Optional Inputs:
%
% dividend_type  -  [Scalar]
%                   Type of dividend information. Default is 0
%                   (dollar dividend). 1 is for dividend yield.
%                   Example: 0
%
% dividend_info  -  Matrix of dollar or yield dividend information,
%                   depending on the input, dividend_type.
%                   First Column is the ex-dividend date corresponding
%                   to the amount in the Second column. Enter any amount
%                   known at any time - does not have to be sorted;
%                   We will use only one(s) within the lifespan of the
%                   option in altering the trees accordingly. This
%                   inclusion will affect the values of settle and
%                   maturity.
%
%                   Default is no dividend.
%
%                   Example : [datenum('2-Jan-2003')  2.0;
%                              datenum('2-Jan-2004')  2.1;
%                              datenum('2-Jan-2005')  2.2];
%                   - for dollar dividend of $2, 2.1, and 2.2
%
%                   or      : [datenum('2-Jan-2003')  0.1;
%                              datenum('2-Jan-2004')  0.1;
%                              datenum('2-Jan-2005')  0.1];
%                   - for yield dividend of 10% of asset prices
%                     on exdividend
%
%  Basis - Scalar value for accrual basis of bond.
%                  0 - actual/actual   (default)
%                  1 - 30/360 (SIA compliant)
%                  2 - actual/360
%                  3 - actual/365
%
% Outputs:
%
% und_matrix      - tree of underlying asset of bond
% pu              - "up" probability
% pd              - "down" probability
%
% Example
%
% So = 52;
% Sigma = 0.4;
% Rf = 0.1;
% Settle = datenum('20-Dec-2002');
% Maturity = datenum('20-May-2003');
% NumStep = 5;
% dividend_type = 0;
% dividend_info = [datenum('5-Apr-2003') ,  2.06];
%
% [tree,pu,pd] = crrbintree(So, Sigma, Rf, Settle, Maturity, ...
%      NumStep, dividend_type, dividend_info);

% Copyright: The MathWorks, Inc.
% $ Revision 1.1 $ $ Date $

if nargin < 6
    error('finfixed:cbprice:crrbintree:invalidInput','Need price, Sigma, Rf, settle, maturity, and numstep');
end

if nargin < 7 || isempty(varargin{1})
    dividend_type = 0;
else
    dividend_type = varargin{1};
end

if nargin < 9 || isempty(varargin{3})
    basis = 0;
else
    basis = varargin{3};
    if any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)
        error('finfixed:cbprice:crrbintree:invalidbasis','Invalid day count basis.');
    end
end

if -1 + prod([size(Rf) size(Sigma) size(price) ...
        size(numbersteps) size(settle) size(maturity) size(dividend_type)])
    error('finfixed:cbprice:crrbintree:scalarInput','All input arguments except dividend_info must be Scalar')
end


if nargin < 8 || isempty(varargin{2})
    dividend_amnt = 0;
    dividend_date = settle;
else
    dividend_info = varargin{2};
    dividend_date = dividend_info(:,1);
    dividend_amnt = dividend_info(:,2);
    relevant_idx = find(dividend_date >= settle &  dividend_date <= maturity);
    if ~isempty(relevant_idx)

        [dividend_date I J] = unique(dividend_date(relevant_idx));
        dividend_amnt = dividend_amnt(I);
    else
        dividend_amnt = 0;
        dividend_date = settle;
    end
end

% time = (maturity - settle)/365.25;
time = yearfrac(settle,maturity,basis);
dt = time/numbersteps;

% time to dividend in the future
% time2div = (dividend_date - settle)' / 365.25;
time2div = yearfrac(settle, dividend_date, basis);

% index to just before exdividend
idx2div = 1+floor(time2div/dt);

up   = exp(Sigma*sqrt(dt));
down = 1/up;
pu   = (exp(Rf*dt) - down) / (up - down);
pd   = 1 - pu;

if any([pd, pu] < 0)
    error('finfixed:cbprice:crrbintree:negativeProbability','Negative probability detected in the tree')
end

switch dividend_type
    case 0
        % set up a cumulative present value reduction in tree

        % number of dividend payment after settle
        num_div = length(dividend_date);

        % initialize 'pseudo' dividend matrix
        dividend_pvtotal = zeros(num_div, numbersteps+1);

        for i = 1:num_div
            % pv only affects nodes prior to coupon
            % dates and here is how we do it:
            dividend_pvtotal(i,1:idx2div(i)) = ...
                exp(-Rf*(time2div(i) - ...
                ((1:idx2div(i)) - 1)*dt))*dividend_amnt(i);
        end

        dividend_pvtotal = sum(dividend_pvtotal,1);

        % tony's trick to create the actual dividend matrix
        dividend_pvtotal = dividend_pvtotal(ones(1,numbersteps+1),:);

        % constructing top branch of tree
        und_matrix = (price - dividend_pvtotal(1)) * up .^ (0:numbersteps);
        seed = down .^ (2 * (0:numbersteps)');
        und_matrix = und_matrix(ones(1,numbersteps+1),:) .* ...
            seed(:,ones(numbersteps+1,1));

        masker = triu(und_matrix);
        masker(masker==0) = nan;
        masker(~isnan(masker)) = 0;

        und_matrix = und_matrix + masker + dividend_pvtotal;

    case 1
        % set up a cumulative multiplier to stock prices in tree
        if any(dividend_amnt < 0 | dividend_amnt > 1)
            error('finfixed:cbprice:crrbintree:invalidDividendYield',['Dividend yield must be between 0 and 1, ', sprintf('\n'), ...
                'denoting fraction of share price to be paid out as dividend'])
        end

        %number of dividend payment after settle
        num_div = length(dividend_date);

        % (1 - total_yield ) = (1 - yield_1) * (1 - yield_2) * ..........
        oneminustotalyield = cumprod(1 - dividend_amnt');

        % initialize dividend_multiplier
        dividend_multiplier = ones(1,numbersteps+1);

        % Because idx2div == 1 means anywhere between node 1 and 2, inclusive.
        % The first node at time zero will be altered only if the first dividend
        % happened exactly at settle.
        % Contrast this with "forward affecting" in the case of dollar dividend.
        if dividend_date(1) == settle
            dividend_multiplier(1) = oneminustotalyield(1);
        end

        for i = 1:num_div-1
            dividend_multiplier(idx2div(i)+1:idx2div(i+1)) = ...
                oneminustotalyield(i);
        end

        % the index to last dividend segment is guaranteed to be at most
        % numbersteps due to FLOOR command
        dividend_multiplier(idx2div(num_div)+1:numbersteps+1) = ...
            oneminustotalyield(num_div);

        % finally, tony's trick to generate the actual multiplier matrix
        dividend_multiplier = dividend_multiplier(ones(1,numbersteps+1),:);

        % constructing top branch of tree
        und_matrix = price * up .^ (0:numbersteps);
        seed = down .^ (2 * (0:numbersteps)');
        und_matrix = und_matrix(ones(1,numbersteps+1),:) .* ...
            seed(:,ones(numbersteps+1,1));

        masker = triu(und_matrix);
        masker(masker==0) = nan;
        masker(~isnan(masker)) = 0;

        % finally multiply underlying matrix with yield matrix
        und_matrix = (und_matrix + masker).*dividend_multiplier ;

    otherwise
        error('finfixed:cbprice:crrbintree:unsupportedDividend',['Unsupported dividend information type, ', sprintf('\n'), ...
            'use 0 for dollar dividend, or 1 for dividend yield'])
end

function [tree_matrix,pu,pm,pd] = ...
    crrtritree(So, Sigma, Rf, Settle, Maturity, numstep, varargin)
% CRRTRITREE Trinomial tree consistent
%            with geometric Brownian motion.
%
%            dS = mu*S*dt + Sigma*S*dz
%
% tree = crrtritree(So, Sigma, Rf, BeginDates, EndDates, ...
%          numstep, dividend_type, dividend_info)
%
% Inputs:
%
% So            - [SCALAR]
%                 Current stock price
%                 Example: 100
%
% Sigma         - [SCALAR]
%                 Annual Volatility in decimal
%                 Example: 0.25 (25%)
%
% Rf            - [SCALAR]
%                 Risk-free rate in decimal, suggested value is
%                 zero-rate treasury with same length
%                 to Maturity.
%                 Example: 0.05 (5%)
%
% BeginDates    - [SCALAR]
%                 Dates corresponding to tree apex.
%                 Example: datenum('20-Dec-2002')
%
% EndDates      - [SCALAR]
%                 Dates corresponding to last column in tree
%                 Example: datenum('20-Dec-2003')
%
% NumStep       - [SCALAR]
%                 Number of time step between Begin- to End-
%                 Dates.
%                 Example: 150
%
% Optional Inputs:
%
% dividend_type - [SCALAR]
%                 Type of dividend information. Default is 0
%                 (dollar dividend). 1 is for dividend yield.
%                 Example: 0
%
% dividend_info - Matrix of dollar or yield dividend information,
%                 depending on the input, dividend_type.
%                 First Column is the ex-dividend date corresponding
%                 to the amount in the Second column. Enter any amount
%                 known at any time - does not have to be sorted;
%                 We will use only one(s) within the lifespan of the
%                 option in altering the trees accordingly. This
%                 inclusion will affect the values of settle and
%                 maturity.
%
%                 Default is no dividend.
%
%                 Example : [datenum('2-Jan-2003')  2.0;
%                            datenum('2-Jan-2004')  2.1;
%                            datenum('2-Jan-2005')  2.2];
%                 - for dollar dividend of $2, 2.1, and 2.2
%
%                 or      : [datenum('2-Jan-2003')  0.1;
%                            datenum('2-Jan-2004')  0.1;
%                            datenum('2-Jan-2005')  0.1];
%                 - for yield dividend of 10% of asset prices
%                   on exdividend
%
% Basis - Scalar value for accrual basis of bond.
%                 0 - actual/actual   (default)
%                 1 - 30/360 (SIA compliant)
%                 2 - actual/360
%                 3 - actual/365
%
% Outputs:
%
% tree          - tree of underlying asset of bond
% pu            - "up" probability
% pm            - "mid" probability
% pd            - "down" probability
%
% Example:
%
% So = 52;
% Sigma = 0.4;
% Rf = 0.1;
% Settle = datenum('20-Dec-2002');
% Maturity = datenum('20-May-2003');
% NumStep = 5;
% dividend_type = 0;
% dividend_info = [datenum('5-Apr-2003') ,  2.06];
%
% [tree,pu,pm,pd] = crrtritree(So, Sigma, Rf, Settle, Maturity, ...
%      NumStep, dividend_type, dividend_info);

% Copyright: The MathWorks, Inc.
% $ Revision 1.1 $ $ Date$

% parsing arguments:
if nargin < 1 || isempty(varargin{1})
    dividend_type = 0;
else
    dividend_type = varargin{1};
end

if nargin < 3 || isempty(varargin{3})
    basis = 0;
else
    basis = varargin{3};
    if any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)
        error('finfixed:cbprice:crrbintree:invalidbasis','Invalid day count basis.');
    end
end

if -1 + prod([size(Rf) size(Sigma) size(So) ...
        size(numstep) size(Settle) size(Maturity) size(dividend_type)])
    error('finfixed:cbprice:crrtrintree:invalidInput','All input arguments except dividend_info must be Scalar')
end

if nargin < 2 || isempty(varargin{2})
    dividend_info = [Settle, 0];
    dividend_amnt = 0;
    dividend_date = Settle;
else
    dividend_info = varargin{2};
    dividend_date = dividend_info(:,1);
    dividend_amnt = dividend_info(:,2);
    relevant_idx = find(dividend_date >= Settle &  dividend_date <= Maturity);

    if ~isempty(relevant_idx)

        [dividend_date I J] = unique(dividend_date(relevant_idx));
        dividend_amnt = dividend_amnt(I);
    else
        dividend_amnt = 0;
        dividend_date = Settle;
    end
end

% T = (Maturity - Settle)/365.25;
T = yearfrac(Settle,Maturity,basis);

deltaT = T/numstep;

u = exp(Sigma*sqrt(3*deltaT));
d = 1/u;

pm = 2/3;
pd = -sqrt(deltaT/12/Sigma^2)*(Rf - Sigma^2/2) + 1/6;
pu = sqrt(deltaT/12/Sigma^2)*(Rf - Sigma^2/2) + 1/6;

if any([pm, pd, pu] < 0)
    error('finfixed:cbprice:crrtritree:negativeProbability','Negative probability detected in the tree')
end

% Initialize matrix
numrow = 2*numstep+1;
numcol = numstep + 1;

% time to dividend in the future
% time2div = (dividend_date - Settle)' / 365.25;
time2div = yearfrac(Settle, dividend_date, basis);

% index to just before exdividend
idx2div = 1+floor(time2div/deltaT);

switch dividend_type
    case 0
        % set up a cumulative present value reduction in tree

        % number of dividend payment after settle
        num_div = length(dividend_date);

        % initialize 'pseudo' dividend matrix
        dividend_pvtotal = zeros(num_div, numcol);

        for i = 1:num_div
            % pv only affects nodes prior to coupon
            % dates and here is how we do it:
            dividend_pvtotal(i,1:idx2div(i)) = ...
                exp(-Rf*(time2div(i) - ...
                ((1:idx2div(i)) - 1)*deltaT))*dividend_amnt(i);
        end

        dividend_pvtotal = sum(dividend_pvtotal,1);

        % tony's trick to create the actual dividend matrix
        dividend_pvtotal = dividend_pvtotal(ones(1,numrow),:);

        tree_matrix = nan * zeros(numrow , numcol);

        % compute the risky component at initial period
        So = So - dividend_pvtotal(1);

        % Compute top-most matrix
        toprow = So * u .^((1:numcol)-1);

        % Create a 1/u^rownumber matrix
        seedmatrix = u .^ -((1:numrow)-1)';
        seedmatrix = seedmatrix(:,ones(numcol,1));

        % masking lower half of tree with nan again
        tree_matrix = toprow(ones(1,numrow),:) .* seedmatrix;

        % nan for irrelevant values under the diag.
        for i = 1:numcol
            tree_matrix(2*i:end,i) = nan;
        end

        tree_matrix = tree_matrix + dividend_pvtotal;

    case 1
        % set up a cumulative multiplier to stock prices in tree
        if any(dividend_amnt < 0 | dividend_amnt > 1)
            error('finfixed:cbprice:crrtritree:invalidDividendYield',['Dividend yield must be between 0 and 1, ', sprintf('\n'), ...
                'denoting fraction of share price to be paid out as dividend'])
        end

        %number of dividend payment after settle
        num_div = length(dividend_date);

        % (1 - total_yield ) = (1 - yield_1) * (1 - yield_2) * ..........
        oneminustotalyield = cumprod(1 - dividend_amnt');

        % initialize dividend_multiplier
        dividend_multiplier = ones(1,numcol);

        % Because idx2div == 1 means anywhere between node 1 and 2,
        % inclusive. The first node at time zero will be altered
        % only if the first dividend happened exactly at settle.
        % Contrast this with "forward affecting" in the case of
        % dollar dividend.
        if dividend_date(1) == Settle
            dividend_multiplier(1) = oneminustotalyield(1);
        end

        for i = 1:num_div-1
            dividend_multiplier(idx2div(i)+1:idx2div(i+1)) = oneminustotalyield(i);
        end

        % the index to last dividend segment is guaranteed to be at most
        % numbersteps due to FLOOR command
        dividend_multiplier(idx2div(num_div)+1:numstep+1) = ...
            oneminustotalyield(num_div);

        % finally, tony's trick to generate the actual multiplier matrix
        dividend_multiplier = dividend_multiplier(ones(1,numrow),:);

        % Compute top-most matrix
        toprow = So * u .^((1:numcol)-1);

        % Create a 1/u^rownumber matrix
        seedmatrix = u .^ -((1:numrow)-1)';
        seedmatrix = seedmatrix(:,ones(numcol,1));

        % masking lower half of tree with nan again
        tree_matrix = toprow(ones(1,numrow),:) .* seedmatrix;

        % nan for irrelevant values under the diag.
        for i = 1:numcol
            tree_matrix(2*i:end,i) = nan;
        end

        % finally multiply underlying matrix with yield matrix
        tree_matrix = tree_matrix.*dividend_multiplier;

    otherwise
        error('finfixed:cbprice:crrtritree:unsupportedDividend',['Unsupported dividend information type, ', sprintf('\n'), ...
            'use 0 for dollar dividend, or 1 for dividend yield'])
end


% [EOF]
