% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch4p3): We also can  plot the step response of systems represented in state 
% space using the step(T,t) command. Here, T is any LTI object and t = a:b:c is 
% the range for the time axis, where a is the initial time, b is the time step size, 
% and c is the final time. For example, t = 0:1:10 means time from 0 to 10 seconds in 
% steps of 1 second. The t field is optional. Finally, in this example we introduce 
% the command, grid on, which superimposes a grid over the step response. Place 
% the grid on command before the step(T,t) command.

'(ch4p3)'                           % Display label.
clf                                 % Clear graph.
A=[0 1 0;0 0 1;-24 -26 -9];         % Generate A matrix.
B=[0;0;1];                          % Generate B vector.
C=[2 7 1];                          % Generate C vector.
D=0;                                % Generate D.
T=ss(A,B,C,D)                       % Generate LTI object, T, in state 
                                    % space and display.
t=0:0.1:10;                         % Define range of time for plot.
grid on                             % Turn grid on for plot.
step(T,t)                           % Plot step response for given 
                                    % range of time.
