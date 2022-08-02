% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch11p3) Example 11.3: Let us use MATLAB to design a lead compensator. The 
% program solves Example 11.3 in the text and follows the same design technique 
% demonstrated in that example. You will enter desired percent overshoot, peak 
% time, and Kv. MATLAB then designs the lead compensator using Bode plots, 
% calculates Kv, and plots a closed-loop step response.

'(ch11p3) Example 11.3'             % Display label.
pos=input('Type %OS  ');            % Input desired percent overshoot.
Tp=input('Type peak time   ');      % Input desired peak time.
Kv=input('Type value of Kv ');      % Input Kv.
numg=[100];                         % Define numerator of G(s).
deng=poly([0 -36 -100]);            % Define denominator of G(s).
G=tf(numg,deng);                    % Create G(s).
s=tf([1 0],1);                      % Create transfer function, 's'.
sG=s*G;                             % Create sG(s).
sG=minreal(sG);                     % Cancel common factors.
K=dcgain(Kv/sG);                    % Solve for K.
'G(s)'                              % Display label.
G=zpk(K*G)                          % Put K into G(s), convert to 
                                    % factored form, and display.
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
Pm=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi);
                                    % Calculate required phase margin.
wn=pi/(Tp*sqrt(1-z^2));             % Calculate required natural 
                                    % frequency.
wBW=wn*sqrt((1-2*z^2)+sqrt(4*z^4-4*z^2+2));
                                    % Determine required bandwidth.
w=0.01:0.5:1000;                    % Set range of frequency from 0.01 to  
                                    % 1000 in steps of 0.5
[M,P]=bode(G,w);                    % Get Bode data.
[Gm,Pm,Wcg,Wcp]=margin(G);          % Find current phase margin.
Pmreq=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi);
                                    % Calculate required phase margin.
Pmreqc=Pmreq+10;                    % Add a correction factor of 10 
                                    % degrees.
Pc=Pmreqc-Pm;                       % Calculate phase contribution 
                                    % required from lead compensator.
% Design lead compensator.

beta=(1-sin(Pc*pi/180))/(1+sin(Pc*pi/180));
                                    % Find compensator beta.
magpc=1/sqrt(beta);                 % Find compensator peak magnitude.
for k=1:1:length(M);                % Find frequency at which 
                                    % uncompensated system has a 
                                    % magnitude of 1/magpc.
                                    % This frequency will be the new 
                                    % phase margin frequency.
if M(k)-(1/magpc)<=0;               % Look for peak magnitude.
wmax=w(k);                          % This is the frequency at the peak 
                                    % magnitude.
break                               % Stop the loop.
end                                 % End if.
end                                 % End for.
% Calculate lead compensator zero, pole, and gain.
zc=wmax*sqrt(beta);                 % Calculate the lead compensator's 
                                    % low break frequency.
pc=zc/beta;                         % Calculate the lead compensator's 
                                    % high break frequency.
Kc=1/beta;                          % Calculate the lead compensator's 
                                    % gain.
'Gc(s)'                             % Display label.
Gc=tf(Kc*[1 zc],[1 pc]);            % Create Gc(s).
Gc=zpk(Gc)                          % Convert Gc(s) to factored form and 
                                    % display.
'Ge(s)=G(s)Gc(s)'                   % Display label.
Ge=G*Gc                             % Form Ge(s)=Gc(s)G(s).
sGe=s*Ge;                           % Create sGe(s).
sGe=minreal(sGe);                   % Cancel common factors.
Kv=dcgain(sGe)                      % Calculate Kv.
T=feedback(Ge,1);                   % Find T(s).
step(T)                             % Generate closed-loop, lead-
                                    % compensated step response.
title('Lead-Compensated Step Response')           
                                    % Add title to lead-compensated step 
                                    % response.
