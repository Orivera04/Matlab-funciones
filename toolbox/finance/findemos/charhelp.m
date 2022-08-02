%CHARHELP This file contains help text strings for Financial Expo on line 
%         help.

%       Author(s): C.F. Garvin, 9-07-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:43:40 $

highlowst = str2mat(...
' Highlow:  High, low, closing, and opening price for a stock.',...
' The bottom of each vertical line shows the low stock price for the day, and the ',...
' top of each line shows the high price for the day.  Right ticks show the closing',...
' price and left ticks show the opening price.  In the absence of opening prices',...
' there are no left ticks, as in this example.  Click Help for more information.');

candlest = str2mat(...
' Candle: Candlestick chart for stock prices.',...
' The candle body is the region between the opening and closing prices for the day.',...
' If the body is filled, closing price is greater than the opening price.  If the body',...
' is empty, the closing price is less than the opening price.  The bottom of a lower',...
' vertical line shows the low price for the day, and the top of an upper vertical',...
' line shows the high price for the day.        ');

barst = str2mat(...
' Bar: A bar chart of stock trading volume.');

movavgst = str2mat(...
' Mov Avg:  Simple moving averages of the stock price.',...
' The chart shows actual prices and two moving averages, leading and lagging.',...
' You can vary the number of days used to compute the moving averages.  Click',...
' the right or left arrow buttons to increase or decrease in increments, or drag',...
' the sliders right or left to increase or decrease by several days.  Then click',...
' Run to see the new chart.');

bollingst = str2mat(...
' Bollinger:  Graph of the stock price using Bollinger bands.',...
' This chart displays the actual prices, a moving average based on the',...
' actual prices, and bands that are two standard deviations above and below',...
' the moving average. You can vary the number of days used to compute the moving',...
' average.  Click the right or left arrow buttons to increase or decrease in',...
' increments, or drag the slider right or left to increase or decrease by several',...
' days.  Then click Run to see the new chart.');