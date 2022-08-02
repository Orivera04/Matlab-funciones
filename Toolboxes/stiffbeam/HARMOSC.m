function y = HARMOSC( t, y, flag, var),
% Equations of first kind order of the oszillation of an 
% harmonical oscillator without damping.
%
% equation:  y'' = A*cos(w*t) - w0^2 * y;
%
% Parameters:
%   t      (input)  : time
%   y      (input)  : actual positions and velocities
%   flag   (-)      : not used
%   mu     (input)  : mass parameter \mu
%   y      (output) : actual value of the right hand side
%
% var: var(1) = w
%      var(2) = w0
%      var(3) = A

% Authors: Stefan Hüeber
% Date   : November 6, 2002
% Version: 1.0

y1 = y(1);

y(1) = y(2);
y(2) = var(3)*cos(var(1)*t) - var(2)^2*y1;