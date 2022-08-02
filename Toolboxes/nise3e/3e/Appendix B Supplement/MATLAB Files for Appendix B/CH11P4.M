% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch11p4) Example 11.4: Let us use MATLAB to design a lag-lead compensator. The 
% program solves Example 11.4 in the text and follows the same design technique 
% demonstrated in that example. You will enter desired percent overshoot, peak 
% time, and Kv. MATLAB then designs the lag-lead compensator using Bode plots, 
% calculates Kv, and plots a closed-loop step response.

'(ch11p4) Example 11.4'             % Display label.
pos=input('Type %OS  ');            % Input desired percent overshoot.
Tp=input('Type peak time   ');      % Input desired peak time.
Kv=input('Type value of Kv ');      % Input desired Kv. 
numg=[1];                           % Define numerator of G(s).
deng=poly([0 -1 -4]);               % Define denominator of G(s).
G=tf(numg,deng);                    % Create G(s) without K.
s=tf([1 0],1);                      % Create transfer function, 's'.
sG=s*G;                             % Create sG(s).
sG=minreal(sG);                     % Cancel common factors.
K=dcgain(Kv/sG);                    % Solve for K.
'G(s)'                              % Display label.
G=tf(K*numg,deng);                  % Put K into G(s).
G=zpk(G)                            % Convert G(s) to factored form and 
                                    % display.
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
Pmreq=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi)+5;
                                    % Calculate required phase margin.
wn=pi/(Tp*sqrt(1-z^2));             % Calculate required natural 
                                    % frequency.
wBW=wn*sqrt((1-2*z^2)+sqrt(4*z^4-4*z^2+2));
                                    % Determine required bandwidth.
wpm=0.8*wBW;                        % Choose new phase-margin frequency.
[M,P]=bode(G,wpm);                  % Get Bode data.
Pmreqc=Pmreq-(180+P);               % Find phase contribution required 
                                    % from lead compensator.
beta=(1-sin(Pmreqc*pi/180))/(1+sin(Pmreqc*pi/180));
                                    % Find beta.	
                                    % Design lag compensator zero, pole, 
                                    % and gain.
zclag=wpm/10;                       % Calculate zero of lag compensator.
pclag=zclag*beta;                   % Calculate pole of lag compensator.
Kclag=beta;                         % Calculate gain of lag compensator.
'Lag compensator, Glag(s)'          % Display label.
Glag=tf(Kclag*[1 zclag],[1 pclag]); % Create lag compensator.
Glag=zpk(Glag)                      % Convert Glag(s) to factored form 
                                    % and display.
                                    % Design lead compensator zero, pole,
                                    % and gain.
zclead=wpm*sqrt(beta);              % Calculate zero of lead compensator.
pclead=zclead/beta;                 % Calculate pole of lead compensator.
Kclead=1/beta;                      % Calculate gain of lead compensator.
'Lead compensator'                  % Display label.
Glead=tf(Kclead*[1 zclead],[1 pclead]);
                                    % Create lead compensator.
Glead=zpk(Glead)                    % Convert Glead(s) to factored form 
                                    % and display.
'Lag-Lead Compensated Ge(s)'        % Display label.
Ge=G*Glag*Glead                     % Create compensated system, 
                                    % Ge(s)=G(s)Glag(s)Glead(s).
sGe=s*Ge;                           % Create sGe(s).
sGe=minreal(sGe);                   % Cancel common factors.
Kv=dcgain(sGe)                      % Calculate Kv
T=feedback(Ge,1);                   % Find T(s).
step(T)                             % Generate closed-loop, lag-lead-
                                    % compensated step response.
title('Lag-Lead-Compensated Step Response')       
                                    % Add title to lag-lead-compensated step
                                    % response.
