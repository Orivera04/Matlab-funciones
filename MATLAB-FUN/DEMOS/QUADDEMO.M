%QUADDEMO Demonstrate adaptive numerical quadrature.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

echo on
clc
%   Quadrature is a technique used to numerically evaluate
%   integrals, i.e. to calculate definite integrals. In MATLAB
%   a function called QUAD implements quadrature using a
%   recursive adaptive Simpson's rule.

%   Consider a function called HUMPS(x) that we've defined in 
%   an M-file on disk,

type humps
pause   % Strike any key to continue.

%   Let's plot this function on the interval from 0 to 1,

fplot('humps',[0,1]')
title('Plot of the function HUMPS(x)'), pause
clc
%   To integrate this function over the interval  0 < x < 1  we
%   invoke QUAD:

% Q = quad('humps',0,1)

pause   % Strike any key to start plot of iterations.
clc

%   QUAD returns the area under the function.
Q = quad('humps',0,1,1e-3,1);
title(['Area is ',num2str(Q)]),
Q

echo off
disp('End')
