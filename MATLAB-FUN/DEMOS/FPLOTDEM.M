%FPLOTDEMO Demonstrate how to plot a function.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
echo on
clc
%   A function called FPLOT is used to plot a function.

%   Consider a function called HUMPS(x) that we've defined in 
%   an M-file on disk,

type humps
pause   % Strike any key to continue.

%   Let's plot this function on the interval from 0 to 2,

fplot('humps',[0,2]);

pause   % Strike any key to continue.

clc
%   Here are the points chosen by the adaptive strategy.

[x,y] = fplot('humps',[0,2]);
plot(x,y,'.')

echo off
