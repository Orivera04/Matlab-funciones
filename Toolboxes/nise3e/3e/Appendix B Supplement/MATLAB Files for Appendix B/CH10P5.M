% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p5) Example 10.11: We can use MATLAB to find the closed-loop 
% frequency response. Let us look at Example 10.11 in the text.


'(ch10p5) Example 10.11'            % Display label.
clf                                 % Clear graph on screen.
numg=50;                            % Define numerator of G(s).
deng=poly([0 -3 -6]);               % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
'T(s)'                              % Display label.
T=feedback(G,1)                     % Find and display closed-loop 
                                    % transfer function.
grid on                             % Turn on the grid for the plots.
bode(T)                             % Make a Bode plot.
title('Closed-Loop Frequency Response')
                                    % Add a title to the Bode plot.
pause
nyquist(T)                          % Make a Nyquist plot.
title('Closed-Loop Frequency Response')
                                    % Add a title to the Nyquist plot.
