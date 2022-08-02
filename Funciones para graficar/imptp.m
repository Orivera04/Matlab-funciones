function ybase=imptp(t,period) 
%
% ybase=imptp(t,period)
% ~~~~~~~~~~~~~~~~~~~~~
% This function defines a piecewise linear 
% function resembling the ground motion of 
% the earthquake which occurred in 1940 in 
% the Imperial Valley of California. The 
% maximum amplitude of base motion is 
% normalized to equal unity.
%
% period - period of the motion 
%          (optional argument)
% t      - vector of times between 
%          tmin and tmax
% ybase  - piecewise linearly interpolated 
%          base motion
%
% User m functions called:  lintrp
%----------------------------------------------

tft=[ ...
  0.00    1.26    2.64    4.01    5.10 ...
  5.79    7.74;   8.65    9.74   10.77 ...
 13.06   15.07   21.60   25.49;  27.38 ...
 31.56   34.94   36.66   38.03   40.67 ...
 41.87;  48.40   51.04   53.80    0    ...
  0       0       0 ]'; 
yft=[ ...
  0       0.92   -0.25    1.00   -0.29 ...
  0.46   -0.16;  -0.97   -0.49   -0.83 ...
  0.95    0.86   -0.76    0.85;  -0.55 ...
  0.36   -0.52   -0.38    0.02   -0.19 ...
  0.08;  -0.26    0.24    0.00    0    ...
  0       0       0 ]';
tft=tft(:); yft=yft(:); 
tft=tft(1:24); yft=yft(1:24);
if nargin == 2 
  tft=tft*period/max(tft); 
end
ybase=lintrp(tft,yft,t);