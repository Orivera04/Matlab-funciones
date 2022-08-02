%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTSPEX4.M
% Financial Toolbox Solving Problems Example 4:
% Constructing Greek-Neutral Portfolios of European Stock Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.6 $   $Date: 2002/04/14 21:43:05 $

% 
% Construct a portfolio that is hedge locally against delta, gamma, 
% and vega, and has a total value of $17,000.
%

%
% STEP 1. 
%
% First, create an input data matrix. Each row contains the standard 
% inputs to the Financial Toolbox Black-Scholes suite of functions: 
% column 1 contains the current price of the underlying stock, column 2
% the strike price of each option, column 3 the time-to-expiry of each
% option in years, column 4 the annualized stock price volatility, and 
% column 5 the annualized dividend rate of the underlying asset. Note 
% that rows 1 and 3 are data related to CALL options, while rows 2 
% and 4 are data related to PUT options.
%
% Also, assume the annualized risk-free rate is 10 percent and is 
% constant for all maturities of interest.
%

riskFreeRate = 0.10;

dataMatrix = [100.000  100  0.2  0.3   0        % Call
              119.100  125  0.2  0.2   0.025    % Put
               87.200   85  0.1  0.23  0        % Call
              301.125  315  0.5  0.25  0.0333]; % Put
%
% Make some assignments just for clarity.
%

stockPrice   = dataMatrix(:,1);
strikePrice  = dataMatrix(:,2);
expiryTime   = dataMatrix(:,3);
volatility   = dataMatrix(:,4);
dividendRate = dataMatrix(:,5);

%
% STEP 2. 
%
% Based on the Black-Scholes model, compute the prices, as well as 
% the delta, gamma, and vega sensitivity greeks of each option. 
% Notice that the functions BLSPRICE and BLSDELTA have two outputs,
% while BLSGAMMA and BLSVEGA have only one. This is because, ceteris
% paribus, the price and delta of a call option will differ from the
% price and delta of an otherwise equivalent put option. This is in
% contrast to the gamma and vega sensitivities which are applicable 
% to both calls and puts.
%

[callPrices, putPrices] = blsprice(stockPrice, strikePrice, riskFreeRate, ...
                                   expiryTime, volatility , dividendRate);

[callDeltas, putDeltas] = blsdelta(stockPrice, strikePrice, riskFreeRate, ...
                                   expiryTime, volatility , dividendRate);


gammas = blsgamma(stockPrice, strikePrice, riskFreeRate, ...
                  expiryTime, volatility , dividendRate)';

vegas  = blsvega (stockPrice, strikePrice, riskFreeRate, ...
                  expiryTime, volatility , dividendRate)';

%
% Extract the prices and deltas of interest to account for the 
% distinction between call and puts.
%

prices = [callPrices(1) putPrices(2) callPrices(3) putPrices(4)];
deltas = [callDeltas(1) putDeltas(2) callDeltas(3) putDeltas(4)];

%
% STEP 3. 
%
% Now, assuming an arbitrary portfolio value is $17,000, set up and 
% solve the linear system of equations such that the overall option 
% portfolio is simultaneously delta, gamma, and vega-neutral. The 
% solution makes use of the fact that the value of a particular greek 
% of a portfolio of options is a weighted average of the corresponding 
% greek of each individual option in the portfolio. The weight applied
% to each greek is simply the quantity of each option included in the
% portfolio. 
%

A = [deltas ; gammas ; vegas ; prices];
b = [  0    ;    0   ;   0   ;  17000];

optionQuantities = A\b;

%
% STEP 4.
%
% Now, summarize the sensitivity information, and verify that the
% portfolio value is indeed $17,000 and that the option portfolio is 
% indeed delta, gamma, and vega neutral as desired.
%

portfolioValue =  prices * optionQuantities;
portfolioDelta =  deltas * optionQuantities;
portfolioGamma =  gammas * optionQuantities;
portfolioVega  =  vegas  * optionQuantities;

disp   (' ')
disp   (' ')
disp   ('    Option  Price    Delta    Gamma    Vega     Quantity')
fprintf('%8d %8.4f %8.4f %8.4f %8.4f %12.4f\n' , [[1:4]' prices' deltas' gammas' vegas' optionQuantities]')
disp   (' ')
fprintf('    Portfolio Value: $%8.2f\n' , portfolioValue)
fprintf('    Portfolio Delta:  %8.2f\n' , portfolioDelta)
fprintf('    Portfolio Gamma:  %8.2f\n' , portfolioGamma)
fprintf('    Portfolio Vega :  %8.2f\n' , portfolioVega)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of FTSPEX4.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
