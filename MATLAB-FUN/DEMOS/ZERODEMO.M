%ZERODEMO This demo shows how to find the zero of a function.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
echo on
clc
%   A function called FZERO is used to find a zero of a function.

%   Consider a function called HUMPS(x) that we've defined in 
%   an M-file on disk,

type humps
pause   % Press any key to continue.

%   Let's plot this function on the interval from 0 to 2,

fplot('humps',[0,2]), grid
title('Notice the zero near x = 1.2'), pause
clc
%   To find a zero of this function near x = 1, we invoke FZERO:

z = fzero('humps',1)
%   And the value above is the zero near 1.0.

pause   % Press any key for plot.

x = 0.4:.02:1.6;
y = humps(x);
plot(x,y,z,humps(z),'.')
title('Zero of humps(x)'), grid

echo off
h = get(gca,'children');
set(h(1),'markersize',35)
