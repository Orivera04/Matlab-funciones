% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 11: Design via Frequency Response
%
% (ch11p1) Example 11.1: We can design via gain adjustment on the Bode plot using 
% MATLAB. You will input the desired percent overshoot from the keyboard. MATLAB 
% will calculate the required phase margin and then search the Bode plot for that 
% phase margin. The magnitude at the phase-margin frequency is the reciprocal of 
% the required gain. MATLAB will then plot a step response for that gain. Let us 
% look at Example 11.1 in the text.

'(ch11p1) Example 11.1'             % Display label.
clf                                 % Clear graph on screen.
numg=[100];                         % Define numerator of G(s).
deng=poly([0 -36 -100]);            % Define denominator of G(s).
G=tf(numg,deng)                     % Create and display G(s).
pos=input('Type %OS  ');            % Input desired percent overshoot.
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
Pm=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi);
                                    % Calculate required phase margin.
w=0.01:0.5:1000;                    % Set range of frequency from 0.01 to 
                                    % 1000 in steps of 0.5.
[M,P]=bode(G,w);                    % Get Bode data.
Ph=-180+Pm;                         % Calculate required phase angle.
for k=1:1:length(P);                % Search Bode data for required phase
                                    % angle.
if P(k)-Ph<=0;                      % If required phase angle is found,
                                    % find the value of 
M=M(k);                             % magnitude at the same frequency.
'Required K'                        % Display label.
K=1/M                               % Calculate the required gain.
break                               % Stop the loop.
end                                 % End if.
end                                 % End for.
T=feedback(K*G,1);                  % Find T(s) using the calculated K.
step(T)                             % Generate a step response.
title(['Closed-Loop Step Response for K= ',num2str(K)])
                                    % Add title to step response.
