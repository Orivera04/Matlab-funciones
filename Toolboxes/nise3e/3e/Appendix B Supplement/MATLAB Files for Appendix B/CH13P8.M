% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p8) Example 13.11:   We now use the root locus to find the gain to meet a 
% transient response requirement. We program MATLAB to allow for keyboard input of 
% the desired damping ratio. MATLAB then produces a z-plane root locus along with 
% the desired damping ratio curve superimposed using the command, zgrid(z,wn). We 
% then interactively select the desired operating point thus determining the 
% gain. MATLAB responds with the gain value as well as the step response of the 
% closed-loop sampled system using step(Tz), where Tz is a digital LTI transfer- 
% function object. Let us look at Example 13.11.

'(ch13p8) Example 13.11'            % Display label.
clf                                 % Clear graph.
numgz=[1 1];                        % Define numerator of G(z).
dengz=poly([1 0.5]);                % Define denominator of G(z).
'G(z)'                              % Display label.
Gz=tf(numgz,dengz,[])               % Create and display G(z).
z=input('Type Damping Ratio  ');    % Input desired damping ratio.
rlocus(Gz)                          % Plot root locus.
zgrid(z,0)                          % Add damping ratio curve to root 
                                    % locus.
title(['z-Plane Root Locus'])       % Add title to root locus.
[K,p]=rlocfind(Gz)                  % Allows input of K by selecting
                                    % point on graphic.
'T(z)'                              % Display label.
Tz=feedback(K*Gz,1)                 % Find T(z).
step(Tz)                            % Find step response of gain-
                                    % compensated system.
title(['Gain Compensated Step Response'])         
                                    % Add title to step response of gain 
                                    % compensated system.
