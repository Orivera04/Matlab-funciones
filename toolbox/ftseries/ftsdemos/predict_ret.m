%
% MATLAB Financial Time Series Toolbox 1.0
%
% Demo ONE:  Exercising FINTS objects for a task...
%
%   Please refer to the Example/Demo Section of the 
%   Financial Time Series Toolbox User's Guide for
%   a more detailed explanation of this Demo
%   session
%
%   Task: Provided with a stock price data series, a 
%         dividend payment series, and an explanatory 
%         (metric) data series, do a regression on the 
%         return of stock.
%
%   Purpose: To show how a task can be accomplished using 
%            the FINTS object and how to manipulate the 
%            object.
%

%   Author: J. H. Akao, 01-06-99
%           P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:50:44 $
%

% Preserve the status of Warning messages.
ws = warning;
warning off;

%-----------------------------------
% Step 1 - Load data needed to carry out the task.  These data 
%          include:
%
%          * Closing prices of a stock on trading days for 1999: sdates, sdata;
%          * Dividend payments per quarter: divdates, divdata;
%          * Explanatory data for returns weekly: expdates, expdata.
%
load predict_ret_data.mat

%-----------------------------------
% Step 2 - Create FINTS objects from the data loaded above:
%          the Closing Price series, the Dividend Payment series, 
%          the Explanatory (metric) series, respectively.
%
t0 = fints(sdates, sdata, {'Close'}, 'd', 'Inc');
d0 = fints(divdates, divdata, {'Dividends'}, 'u', 'Inc');
x0 = fints(expdates, expdata, {'Metric'}, 'w', 'Index');

%-----------------------------------
% Step 3 - Make adjustments to the stock price to account for the 
%          dividend payments.
%
% The stock price is increased by the dividend just before the 
% payment.  So, we create a time series identical to the dividend 
% payments series with the dates subtracted by 1.
%
dadj1       = d0;
dadj1.dates = dadj1.dates-1;

% The stock price is increased by 0 on the day of the payment.  
% Similarly, we create a time series identical to the dividend 
% payments series with the values on the payment dates of 0.
% Plus, we roll back to the previous payment on 12/31/98.
%
dadj2             = d0;
dadj2.Dividends   = 0;
dadj2             = fillts(dadj2,'linear','12/31/98');
dadj2('12/31/98') = 0;

% Combine the 2 series into 1 adjustment factor series.
%
dadj3 = [dadj1; dadj2];
  
% Now fill linearly to the stock dates (daily).
%
dadj3 = fillts(dadj3, 'linear', t0.dates);
  
%-----------------------------------
% Step 4 - Add the adjustments to the Closing Prices to create the 
%          Spot Prices series.
%
t0.Spot = t0.Close - fts2mat(dadj3(datestr(t0.dates)));

%-----------------------------------
% Step 5 - Create a Return series.
%
% The Return series is the ratio of the difference between the 
% current Spot Price and the previous Spot Price to the previous 
% Spot Price.
%
tret = ( t0.Spot - lagts(t0.Spot, 1) ) ./ lagts(t0.Spot, 1);

% Since the above operation preserve the data series name for the 
% new series; we need to change it so that it reflects the correct 
% contents.
%
tret = chfield(tret, 'Spot', 'Return');

%-----------------------------------
% Step 6 - Regress the returns against the metric.
%
% Since the metric data is a weekly data, we need to make sure that 
% the frequency of the data matches.  So, we convert the weekly data 
% to daily data.
%
x1 = todaily(x0);

% We need to add a dummy constant so that when we do the regression, 
% we can get the constant offset from the regression.
%
x1.Const = 1;

% Create a common time series by combining the contents of the 
% Return series and the metric series whose dates exist in both 
% series.  When you horizontally concatenate 2 series, the names 
% of the data series will have suffixes; these suffixes are in the 
% form of _N where N is the order number of the time series object.
% In this case, N=1 refers to 'tret' and N=2 refers to 'x1'.
% 
dcommon = intersect(tret.dates, x1.dates);
regts0  = [tret(datestr(dcommon)), x1(datestr(dcommon))];

% Find values that are not finite and squeeze them out.  Infinite 
% values include NaN and Inf.
%
finite_regts0 = find(all( isfinite( fts2mat(regts0) ), 2));
regts1        = regts0( finite_regts0 );

% Get the values out of the object so that we can do regression on
% them.  Compute regression coefficients by hand using the backslash 
% operator (i.e. minimize( XMatrix * XCoeff - RetMatrix )).
%
DataMatrix = fts2mat( regts1 );
XCoeff     = DataMatrix(:, 2:3) \ DataMatrix(:, 1);

% Compute regression coefficients by hand using the backslash 
% operator (i.e. minimize( XMatrix * XCoeff - RetMatrix )).
%
%XCoeff = XMatrix \ RetMatrix;

% Compute the prediction.
%
RetPred = DataMatrix(:, 2:3) * XCoeff;

% Put the prediction back into the return time series
%
tret.PredReturn( datestr(regts1.dates) ) = RetPred;

%-----------------------------------
% Step 7 - Show the results.
%
% Show the plot of the Spot and Closing Prices, and the 
% Actual Return and the Predicted Return...
%
subplot(2, 1, 1);
plot(t0);
title('Spot and Closing Prices of Stock');
subplot(2, 1, 2);
plot(tret);
title('Actual and Predicted Return of Stock');

%-----------------------------------
% Step 8 - Find the Dividend Rate (i.e. the dividend divided by 
%          the closing stock price on the dividend dates.
%
% However, there is a problem here.  We do not have the stock price 
% data for one of the dividend dates.  What we need to do is to use 
% FILLTS to add the missing date and interpolate for the price on 
% that date.
%
t1 = fillts(t0,'nearest',d0.dates);
t1.freq = 'd';

% Once we have the stock price filled, we can use it to calculate 
% the Dividend Rate.
%
tdr = d0./fts2mat(t1.Close( datestr(d0.dates) ));

%
% End of Demo ONE.
%

% Restore the status of Warning messages.
warning(ws);

