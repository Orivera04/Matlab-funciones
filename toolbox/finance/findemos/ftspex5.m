%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTSPEX5.M
% Solving Problems with the Financial Toolbox Example 5:
% Term Structure Analysis and Interest Rate Swap Pricing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.5 $   $Date: 2002/04/14 21:43:08 $

%
% Assume, for simplicity, that all bonds pay coupons semi-annually 
% and that settlement occurs on a coupon payment date to avoid issues 
% of accrued interest. The following simplistic analysis illustrates 
% how to price a plain-vanilla interest rate swap using some of the
% term structure analysis functions found in the Financial Toolbox.
%

%
% STEP 1.
%
% First, specify the settlement date, and the maturity dates, coupon 
% rates, and observed market prices for 10 U.S. Treasury Bonds.
% Notice that settlement is on a coupon payment date for each bond, 
% and that coupons are paid semi-annually. 
%

settle   = datenum('15-Jan-1999');

BondData = {'15-Jul-1999'  0.06000   99.93
            '15-Jan-2000'  0.06125   99.72
            '15-Jul-2000'  0.06375   99.70
            '15-Jan-2001'  0.06500   99.40
            '15-Jul-2001'  0.06875   99.73
            '15-Jan-2002'  0.07000   99.42
            '15-Jul-2002'  0.07250   99.32
            '15-Jan-2003'  0.07375   98.45
            '15-Jul-2003'  0.07500   97.71
            '15-Jan-2004'  0.08000   98.15};

maturity   = datenum(strvcat(BondData{:,1}));
couponRate = [BondData{:,2}]';
prices     = [BondData{:,3}]';
period     = 2;                    % semi-annual coupons

%
% STEP 2.
%
% Now, using the term structure function ZBTPRICE, bootstrap
% the zero (i.e., spot) curve implied from the prices of the
% coupon-bearing bonds. This implied zero curve represents the
% series of zero-coupon Treasury rates consistent with the
% prices of the coupon-bearing bonds such that arbitrage 
% opportunities will not exist.
%

zeroRates = zbtprice([maturity couponRate] , prices , settle); 

%
% STEP 3.
%
% From the implied zero curve, now find the corresponding 
% series of implied forward rates using the term structure 
% function ZERO2FWD.
%

forwardRates = zero2fwd(zeroRates , maturity , settle);

%
% STEP 4.
%
% Use the term structure function ZERO2DISC to compute the
% sequence of discount factors corresponding to the implied
% zero curve.
%

discountFactors = zero2disc(zeroRates , maturity , settle);

%
% STEP 5.
%
% From the discount factors, compute the present value of the
% variable cash flows derived from the implied forward rates. 
% For plain-vanilla interest rate swaps, the notional 
% principle remains constant for each payment date, and 
% cancels out of each side of the equation. The line below
% assumes unit notional principle.
%

presentValue = sum((forwardRates/period) .* discountFactors);

%
% STEP 6.
%
% Now compute the swap's price (i.e., the fixed rate) by
% equating the present value of the fixed cash flows with the
% present value of the cash flows derived from the implied
% forward rates. Again, since the notional principle cancels 
% out of each side of the equation, it is simply assumed to be 1.
%

swapFixedRate = period * presentValue / sum(discountFactors);

%
% Finally, print the zero and forward curves, and 
% the swap price to the screen for confirmation.
%

disp(' ')
disp('  Zero Rates   Forward Rates')
fprintf('%10.4f  %12.4f\n' , [zeroRates forwardRates]')
fprintf('\n  Swap Price (i.e., Fixed Rate) = %6.4f\n' , swapFixedRate)
