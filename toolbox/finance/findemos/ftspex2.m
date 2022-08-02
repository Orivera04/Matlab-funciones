%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTSPEX2.M
% Solving Problems with the Financial Toolbox Example 2:
% Constructing a Bond Portfolio to Hedge Against Duration and Convexity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:42:56 $

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
maturity   = ['15-Jun-2005' ; '02-Oct-2010' ; '01-Mar-2025'];
Face       = [500  ;  1000  ;  250];
couponRate = [0.07 ;  0.066 ; 0.08];

%
% Now specify the points on the yield curve for each bond.
%

yields = [0.06 ; 0.07 ; 0.075];

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
% Solve the system of equations for the hedging weights of each
% bond. The system is solved by viewing the portfolio duration
% and convexity as a weighted average of the durations and 
% convexities of the individual bonds. Also, the hedge weights
% are required to sum to 1.
%
% Since Ax = b, in MATLAB x = A\b
%

A = [durations'
     convexities'
     1 1 1];

b = [ 10.3181           % portfolio duration  from Example 1.
     157.6346           % portfolio convexity from Example 1.
       1];

weights = A\b;

%
% STEP 4.
%
% The duration and convexity of the portfolio should now match
% that of the portfolio in Example 1 (see FTSPEX1.M).
%

portfolioDuration  = weights' * durations;
portfolioConvexity = weights' * convexities;

%
% STEP 5.
%
% Scale the portfolio to match the value of the portfolio 
% in Example 1 (see FTSPEX1.M). The hedge amounts are the
% number of bonds required to form a duration/convexity
% neutral hedge for the portfolio in Example 1.
%

portfolioValue = 100000;
hedgeAmounts   = weights ./ prices * portfolioValue;

disp(' ')
disp(['  Portfolio  Duration: ' num2str(portfolioDuration ,'%-8.2f')])
disp(['  Portfolio Convexity: ' num2str(portfolioConvexity,'%-8.2f')])
disp(['  Bond Hedge Amounts : ' num2str(hedgeAmounts' ,'%-8.2f%-8.2f%-8.2f')])
disp(' ')
