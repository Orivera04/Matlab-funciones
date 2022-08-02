% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch11p2) Example 11.2: Let us use MATLAB to design a lag compensator. The 
% program solves Example 11.2 in the text and follows the same design technique 
% demonstrated in that example. You will input the value of gain to meet the 
% steady-state error requirement followed by the desired percent overshoot. MATLAB 
% then designs a lag compensator, evaluates Kv, and generates a closed-loop step 
% response.  

'(ch11p2) Example 11.2'             % Display label.
clf                                 % Clear graph on screen.
K=input('Type value of K to meet steady-state error requirement ');
                                    % Input K.
pos=input('Type %OS  ');            % Input desired percent overshoot.
numg=[100*K];                       % Define numerator of G(s).
deng=poly([0 -36 -100]);            % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
Pm=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi)+10;
                                    % Calculate required phase margin.
w=0.01:0.1:100;                     % Set range of frequency from 0.01 to
                                    % 1000 in steps of 0.1.
[M,P]=bode(G,w);                    % Get Bode data.
Ph=-180+Pm;                         % Calculate required phase angle.
for k=1:1:length(P);                % Search Bode data for required phase
                                    % angle.
if P(k)-Ph<=0;                      % If required phase angle is found, 
                                    % find the value of 
M=M(k);                             % magnitude at the same frequency.
wf=w(k);                            % At this frequency the magnitude
                                    % plot must go through 0 dB.
break                               % Stop the loop.
end                                 % End if.
end                                 % End for.
wh=wf/10;                           % Calculate the high-frequency break 
                                    % of the lag compensator.
wl=(wh/M);                          % Calculate the low-frequency break
                                    % of the lag compensator. Found from
                                    % lag compensator, Gc(s)=Kc(s+wh)/(s+wl),
                                    % high & low frequency gain requirements.
                                    % At low w gain=1. Thus, Kc*wh/wl=1.
                                    % At high w gain=1/M. Thus Kc=1/M. Hence
                                    % Kc=wl/wh=1/M, or wl=wh/M.
numc=[1 wh];                        % Generate numerator of lag 
                                    % compensator, Gc(s).
denc=[1 wl];                        % Generate denominator of lag  
                                    % compensator, Gc(s).
Kc=wl/wh;                           % Generate K for Gc(s).
'Lag compensator'                   % Display label.
Kc                                  % Display lag compensator K.
'Gc(s)'                             % Display label.
Gc=tf(Kc*numc,denc)                 % Create and display Gc(s).
'Gc(s)G(s)'                         % Display label.
GcG=Gc*G                            % Create and display Gc(s)G(s).
s=tf([1 0],1);                      % Create transfer function, 's'.
sGcG=s*GcG;                         % Create sGc(s)G(s).
sGcG=minreal(sGcG);                 % Cancel common terms.
Kv=dcgain(sGcG)                     % Evaluate Kv.
T=feedback(GcG,1);                  % Create T(s). 
step(T)                             % Generate a closed-loop, lag-
                                    % compensated step response. 
title('Closed-Loop Step Response for Lag-Compensated System')
                                    % Add title to step response.
