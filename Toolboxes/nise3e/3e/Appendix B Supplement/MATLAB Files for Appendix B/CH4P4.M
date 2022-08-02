% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch4p4) Antenna Control Case Study: We now use MATLAB to plot the step response 
% requested in the Antenna Control Case Study.

'(ch4p4) Antenna Control Case Study' 
                                    % Display label.
clf                                 % Clear graph.
numg=20.83;                         % Define numerator of G(s).
deng=[1 101.71 171];                % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Form and display transfer function 
                                    % G(s).
step(G);                            % Generate step response.
title('Angular Velocity Response')  % Add title.
