% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p7) Example 10.15: We can use MATLAB and frequency response methods to 
% include time delay in the loop. Time delay is represented by 
% [numd,dend] = pade(T,n), where T is the delay time in seconds and n is the order. 
% Larger values of n give better approximations to the delay, Gd(s) = numd/dend.
% Since we are plotting multiple plots, we first collect the data for the Bode 
% plots by using [mag,phase] = bode(G,w), where w is specified as a range of 
% frequencies. We then use the generic plotting command. Also notice the commands 
% used to label the axes and the plots on the Bode plot (see the MATLAB instruction 
% manual for details). Let us look at Example 10.15 in the text.

'(ch10p7) Example 10.15'            % Display label.
clf                                 % Clear graph on screen.
hold off                            % Turn graph hold off.
numg=1;                             % Define numerator of G(s).
deng=poly([0 -1 -10]);              % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
w=0.01:0.1:10;                      % Let 0.01<w<10 in steps of 0.1.
[magg,phaseg]=bode(G,w);            % Collect Bode data for G(s).
[numd,dend]=pade(1,6);              % Represent the delay.
Gd=tf(numd,dend);                   % Create and display the delay, 
                                    % Gd(s).
[magd,phased]=bode(Gd,w);           % Collect Bode data for Gd(s).
Ge=Gd*G;                            % Form Gd(s)G(s).
[mage,phasee]=bode(Ge,w);           % Collect Bode data for Gd(s)G(s).
subplot(2,1,1)                      % Subdivide plot area for plot 1.
semilogx(w,20*log10(mage(:,:)))     % Plot magnitude response.
grid on                             % Turn on grid for magnitude plot.
axis([0.01,10,-80,20]);             % Limit Bode plot axes.
title('Magnitude Response with Delay')		
                                    % Add title to magnitude response.
xlabel('Frequency (rad/s)')         % Label x axis of magnitude 
                                    % response.
ylabel('20log M')                   % Label y axis of magnitude response.
subplot(2,1,2)                      % Subdivide plot area for plot 2.
semilogx(w,phaseg(:,:),w,phased(:,:),w,phasee(:,:))		
                                    % Plot phase response for G(s), 
                                    % Gd(s), and G(s)Gd(s) on one graph.
grid on                             % Turn on grid for phase plot.
axis([0.01,10,-900,0]);             % Limit Bode plot axes.
title('Phase Response with Delay')  % Add title to phase response.
xlabel('Frequency (rad/s)')         % Label x axis of phase response.
ylabel('Phase (degrees)')           % Label y axis of phase response.
text(1.5,-50,'Time Delay')          % Label time delay curve.
text(4,-150,'System')               % Label system curve.
text(2.7,-300,'Total')              % Label total curve.
