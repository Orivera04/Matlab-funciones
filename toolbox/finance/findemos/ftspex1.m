%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTSPEX1.M
% Solving Problems with the Financial Toolbox Example 1:
% Sensitivity of Bond Prices to Changes in Interest Rates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:42:44 $

%
% STEP 1.
%
% Specify SIA-compliant bond information. Accept default values for 
% coupon payment periodicity (2 = semi-annual), end-of-month 
% payment rule (1 = end-of-month rule in effect), and day-count 
% basis (0 = actual/actual). Also, synchronize the coupon payment 
% structure to the maturity date (i.e., leave the first and last 
% coupon date unspecified for simplicity).
%

settle     = '19-Aug-1999';
maturity   = ['17-Jun-2010' ; '09-Jun-2015' ; '14-May-2025'];
Face       = [100  ;   100  ; 1000];
couponRate = [0.07 ;  0.06  ; 0.045];

%
% Now specify the points on the yield curve for each bond.
%

yields = [0.05 ; 0.06 ; 0.065];

%
% STEP 2.
%
% Compute the true (i.e., dirty) prices, 
% durations and convexities of each bond.
%

[cleanPrice, accruedInterest] = bndprice(yields, couponRate, settle, maturity, ...
                                         2, 0, [] , [] , [] , [], [] , Face);

durations = bnddury(yields, couponRate, settle, maturity, ...
                    2, 0, [] , [] , [] , [], [] , Face);

convexities = bndconvy(yields, couponRate, settle, maturity, ...
                       2, 0, [] , [] , [] , [], [] , Face);

prices  =  cleanPrice + accruedInterest;

%
% STEP 3.
%
% Assume an equally-weighted portfolio, and calculate the 
% actual dollar amount of each bond.
%

dY = 0.002;      % Yield curve shift.

portfolioPrice   = 100000;
portfolioWeights = ones(3,1)/3;
portfolioAmounts = portfolioPrice * portfolioWeights ./ prices;

%
% STEP 4.
%
% Compute the modified duration & convexity of the portfolio; and
% estimate the 1st & 2nd order percentage price changes.
%

portfolioDuration  = portfolioWeights' * durations;
portfolioConvexity = portfolioWeights' * convexities;

percentApprox1 = -portfolioDuration * dY * 100;
percentApprox2 =  percentApprox1 + portfolioConvexity * dY^2 * 100/2.0;

%
% STEP 5.
%
% Now approximate the new portfolio value based on the 1st (duration-based 
% only) and 2nd order (duration and convexity) percentage price changes.
%

priceApprox1  =  portfolioPrice + percentApprox1 * portfolioPrice/100;
priceApprox2  =  portfolioPrice + percentApprox2 * portfolioPrice/100;

%
% STEP 6.
%
% Now compute the true new portfolio value by shifting the yield curve.
%

[cleanPrice, accruedInterest] = bndprice(yields + dY, couponRate, settle, ...
                                         maturity, 2, 0, [], [], [], [], [], Face);

newPrice  =  portfolioAmounts' * (cleanPrice + accruedInterest);

%
% STEP 7.
%
% Now examine the results. 
%

disp(' ')
disp(['  Portfolio  Duration                       : ' num2str(portfolioDuration ,'%-8.2f')])
disp(['  Portfolio Convexity                       : ' num2str(portfolioConvexity,'%-8.2f')])
disp(' ')
disp(['  Portfolio Value Using Duration Only       : ' cur2str(priceApprox1)])
disp(['  Portfolio Value Using Duration & Convexity: ' cur2str(priceApprox2)])
disp(['  True Portfolio Value via Re-pricing       : ' cur2str(newPrice)])
