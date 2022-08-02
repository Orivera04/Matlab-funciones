% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch8p2) Example 8.8: We can couple the design of gain on the root locus with a 
% step response simulation for the gain selected. We introduce the command 
% rlocus(G,K), which allows us to specify the range of gain, K, for plotting the root 
% locus. This command will help us smooth the usual root locus plot by equivalently 
% specifying more points via the argument, K. Notice that the first root locus 
% plotted without the argument K is not smooth. We also introduce the command, 
% x = input('prompt'), which allows keyboard entry of a value for x in response to a 
% prompt. We apply this command to enter the desired percent overshoot. We also add 
% a variable's value to the title of the root locus and step response plots by 
% inserting another field in the title command and use num2str(value) to convert 
% value from a number to a character string for display.  Let us apply the concepts 
% to Example 8.8 in the text.

'(ch8p2) Example 8.8'               % Display label.
clear                               % Clear variables from workspace.
clf                                 % clear graph on screen.
numg=[1 1.5];                       % Define numerator of G(s).
deng=poly([0 -1 -10]);              % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
rlocus(G)                           % Draw root locus (H(s)=1).
title('Original Root Locus')        % Add title.
pause
K=0:.5:50;                          % Specify range of gain to smooth
                                    % root locus.
rlocus(G,K)                         % Draw smoothed root locus (H(s)=1).
title('Smoothed Root Locus')        % Add title.
pos=input('Type %OS  ');            % Input desired percent overshoot
                                    % from the keyboard.
z=-log(pos/100)/sqrt(pi^2+[log(pos/100)]^2)
                                    % Calculate damping ratio.
sgrid(z,0)                          % Overlay desired damping ratio line
                                    % on root locus.
title(['Root Locus with ',num2str(pos),'% overshoot line'])
                                    % Define title for root locus
                                    % showing percent overshoot used.
[K,p]=rlocfind(G)                   % Generate gain, K, and closed-loop 
                                    % poles, p, for point selected 
                                    % interactively on the root locus.
pause
'T(s)'                              % Display label.
T=feedback(K*G,1)                   % Find closed-loop transfer function
                                    % with selected K and display.
step(T)                             % Generate closed-loop step response
                                    % for point selected on root locus.
title(['Step Response for K=',num2str(K)])            
                                    % Give step response a title which 
                                    % includes the value of K.
