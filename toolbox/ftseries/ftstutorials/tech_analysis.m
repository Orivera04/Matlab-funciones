% MATLAB Financial Time Series Toolbox 2.0
%
% Tutorial THREE:  Technical Analysis...
%
%    Please refer to the Tutorial Section of the 
%    Financial Time Series Toolbox User's Guide for
%    a more detailed explanation of this tutorial
%    session

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:32:38 $

%%% Start of Tutorial THREE %%%
clc
disp('   ');
disp('Tutorial THREE: Technical Analysis...');
disp('   ');
disp('You should be able to see the contents of the objects, ');
disp('by using the scroll bar on the right.  In the event that the ');
disp('scroll bar does not allow you to see the whole contents of the ');
disp('object, you should terminate this tutorial session by pressing ');
disp('Ctrl-C command and, then, turn on the MORE feature of MATLAB by ');
disp('issuing ''more on'' at the command prompt.  Once you have that ');
disp('feature turned on, rerun this tutorial again.');
disp('   ');
disp('Good luck and enjoy...');
disp('   ');
disp('   ');
disp('   ');
disp('Press any key to continue...');
pause

%% Load the data series to be used throughout the tutorial.
%% And, extract a part of the data set so as to not use the 
%% whole data series.  And, use FILLTS to fill any missing 
%% values due to holidays within the period.
clear
clc
fprintf('\nLoading IBM Stock Prices data between 10/01/95 to 12/31/95...\n');
fprintf('\nPlease wait...\n');
drawnow;
ibm = ascii2fts('ibm9599.dat', 1, 3, 2);
part_ibm = fillts( ibm('10/01/95::12/31/95') );
fprintf('\nPress any key to continue...\n');
pause

%%
%% Oscillators: MACD Example.
%%
clc
fprintf('\nMACD Example...\n');
fprintf('\n');
fprintf('\nPress any key to calculate the MACD line(s)...\n');
fprintf('\n» macd_ibm = macd(part_ibm);');
pause
macd_ibm = macd(part_ibm);
fprintf('\n\nDone calculating MACD...\n');
fprintf('\n\nPress any key to continue...\n');
pause

% Plot the MACD line(s) in the top plot of a 2-plot figure window.
fprintf('\n\n');
fprintf('\nMACD Example Plots...\n');
fprintf('\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
fprintf('\nPress any key to plot the results...\n');
pause
subplot(2, 1, 1);
plot(macd_ibm);
title('MACD of IBM Close Stock Prices, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
% Plot the High-Low chart of the IBM Stock Prices in the bottom plot.
subplot(2, 1, 2);
highlow(part_ibm);
title('IBM Stock Prices, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
fprintf('\n\nPress any key to continue...\n');
pause

%%
%% Stochastics: William's %R Example.
%%
close all
clc
fprintf('\nWilliam''s %%R Example...\n');
fprintf('\n');
fprintf('\nPress any key to calculate the William''s %%R line...\n');
fprintf('\n» wpctr_ibm = willpctr(part_ibm);');
pause
wpctr_ibm = willpctr(part_ibm);
fprintf('\n\nDone calculating William''s %%R...\n');
fprintf('\n\nPress any key to continue...\n');
pause

% Plot the William's %R line in the top plot of a 2-plot figure window.
fprintf('\n\n');
fprintf('\nWilliam''s %%R Example Plots...\n');
fprintf('\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
fprintf('\nPress any key to plot the results...\n');
pause
subplot(2, 1, 1);
plot(wpctr_ibm);
title('William''s %R of IBM Stock, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
hold on;
plot(wpctr_ibm.dates, -80*ones(1, length(wpctr_ibm)), 'color', [0.5 0 0], 'linewidth', 2)
plot(wpctr_ibm.dates, -20*ones(1, length(wpctr_ibm)), 'color', [0 0.5 0], 'linewidth', 2)
% Plot the High-Low chart of the IBM Stock Prices in the bottom plot.
subplot(2, 1, 2);
highlow(part_ibm);
title('IBM Stock Prices, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
fprintf('\n\nPress any key to continue...\n');
pause

%%
%% Indeces: RSI Example.
%%
close all
clc
fprintf('\nRelative Strength Index (RSI) Example...\n');
fprintf('\n');
fprintf('\nPress any key to calculate the William''s %%R line...\n');
fprintf('\n» rsi_ibm = rsindex(part_ibm);');
pause
rsi_ibm = rsindex(part_ibm);
fprintf('\n\nDone calculating RSI...\n');
fprintf('\n\nPress any key to continue...\n');
pause

% Plot the William's %R line in the top plot of a 2-plot figure window.
fprintf('\n\n');
fprintf('\nRelative Strength Index (RSI) Example Plots...\n');
fprintf('\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
fprintf('\nPress any key to plot the results...\n');
pause
subplot(2, 1, 1);
plot(rsi_ibm);
title('RSI of IBM Stock, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
hold on;
plot(rsi_ibm.dates, 30*ones(1, length(wpctr_ibm)), 'color', [0.5 0 0], 'linewidth', 2)
plot(rsi_ibm.dates, 70*ones(1, length(wpctr_ibm)), 'color', [0 0.5 0], 'linewidth', 2)
% Plot the High-Low chart of the IBM Stock Prices in the bottom plot.
subplot(2, 1, 2);
highlow(part_ibm);
title('IBM Stock Prices, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
fprintf('\n\nPress any key to continue...\n');
pause

%%
%% Indicators: On-Balance Volume Example.
%%
close all
clc
fprintf('\nOn-Balance Volume (OBV) Example...\n');
fprintf('\n');
fprintf('\nPress any key to calculate the William''s %%R line...\n');
fprintf('\n» obv_ibm = onbalvol(part_ibm);');
pause
obv_ibm = onbalvol(part_ibm);
fprintf('\n\nDone calculating OBV...\n');
fprintf('\n\nPress any key to continue...\n');
pause

% Plot the William's %R line in the top plot of a 2-plot figure window.
fprintf('\n\n');
fprintf('\nOn-Balance Volume (OBV) Example Plots...\n');
fprintf('\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
fprintf('\nPress any key to plot the results...\n');
pause
subplot(2, 1, 1);
plot(obv_ibm);
title('On-Balance Volume of IBM Stock, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
% Plot the High-Low chart of the IBM Stock Prices in the bottom plot.
subplot(2, 1, 2);
highlow(part_ibm);
title('IBM Stock Prices, 10/01/95-12/31/95');
datetick('x', 'mm/dd/yy');
fprintf('\n\nPress any key to continue...\n');
pause

%%% End of Tutorial THREE %%%
close all
clear
clc
disp('   ');
disp('End of Tutorial THREE...');
disp('   ');
disp('There are a couple of DEMO files in the FTSDEMOS directory. ');
disp('You can use them to get more idea about the FINTS objects and ');
disp('what you can do with them.');
disp('...');
disp('   ');
disp('   ');
disp('   ');

