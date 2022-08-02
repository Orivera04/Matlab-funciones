% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 9: Design via Root Locus
%
% (ch9p1) Example 9.3: We can use MATLAB to design PD controllers. The program 
% allows us to input a desired percent overshoot via the keyboard. MATLAB then 
% produces a root locus for the uncompensated system with an overlay of the 
% percent overshoot line. We interactively select the intersection of the root 
% locus and the desired percent overshoot line to set the gain. MATLAB outputs an 
% estimate of the uncompensated system's performance specifications and a step 
% response of the uncompensated system for us to determine the required settling 
% time. After we input the settling time through the keyboard, MATLAB designs the 
% PD controller and produces a root locus of the PD compensated system from which 
% we can interactively select the gain. Finally, MATLAB produces an estimate of 
% the PD compensated system's performance specifications and a step response of 
% the PD compensated system. 

'(ch9p1) Example 9.3'               % Display label.
clf                                 % Clear graph on screen.
'Uncompensated System'              % Display label.
numg=1;                             % Generate numerator of G(s).
deng=poly([0 -4 -6]);               % Generate denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
pos=input('Type desired percent overshoot ');
                                    % Input desired percent overshoot.
z=-log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
                                    % Calculate damping ratio.
rlocus(G)                           % Plot uncompensated root locus.
sgrid(z,0)                          % Overlay desired percent overshoot 
                                    % line.
title(['Uncompensated Root Locus with ' , num2str(pos),...
'% Overshoot Line'])                % Title uncompensated root locus.
[K,p]=rlocfind(G);                  % Generate gain, K, and closed-loop 
                                    % poles, p, for point selected 
                                    % interactively on the root locus.
'Closed-loop poles = '              % Display label.
p                                   % Display closed-loop poles.
f=input('Give pole number that is operating point   ');
                                    % Choose uncompensated system 
                                    % dominant pole.
'Summary of estimated specifications for selected point on' 
'uncompensated root locus'          % Display label.
operatingpoint=p(f)                 % Display uncompensated dominant
                                    % pole.
gain=K                              % Display uncompensated gain.
estimated_settling_time=4/abs(real(p(f)))
                                    % Display uncompensated settling
                                    % time.
estimated_peak_time=pi/abs(imag(p(f)))
                                    % Display uncompensated peak time.
estimated_percent_overshoot=pos     % Display uncompensated percent
                                    % overshoot.
estimated_damping_ratio=z           % Display uncompensated damping
                                    % ratio.
estimated_natural_frequency=sqrt(real(p(f))^2+imag(p(f))^2)
                                    % Display uncompensated natural 
                                    % frequency.
numkv=conv([1 0],numg);             % Set up numerator to evaluate Kv.
denkv=deng;                         % Set up denominator to evaluate Kv.
sG=tf(numkv,denkv);                 % Create sG(s).
sG=minreal(sG);                     % Cancel common poles and zeros.
Kv=dcgain(K*sG)                     % Display uncompensated Kv.
ess=1/Kv                            % Display uncompensated steady-state
                                    % error for unit ramp input.
'T(s)'                              % Display label.
T=feedback(K*G,1)                   % Find uncompensated T(s).	
step(T)                             % Plot step response of uncompensated
                                    % system.
title(['Uncompensated System Step Response with ',num2str(pos),...
'% Overshoot'])                     % Add title to uncompensated step 
                                    % response.
'Press any key to go to PD compensation'
                                    % Display label.
pause
'Compensated system'                % Display label.
Ts=input('Type Desired Settling Time ');
                                    % Input desired settling time from 
                                    % the keyboard.
wn=4/(Ts*z);                        % Calculate natural frequency.
desired_pole=(-z*wn)+(wn*sqrt(1-z^2)*i);
                                    % Calculate desired dominant pole
                                    % location.
angle_at_desired_pole=(180/pi)*...
angle(polyval(numg,desired_pole)/polyval(deng,desired_pole));
                                    % Calculate angular contribution to
                                    % desired pole without PD 
                                    % compensator.
PD_angle=180-angle_at_desired_pole; % Calculate required angular 
                                    % contribution from PD compensator.
zc=((imag(desired_pole)/tan(PD_angle*pi/180))-real(desired_pole));
                                    % Calculate PD zero location.
'PD Compensator'                    % Display label.
numc=[1 zc];                        % Calculate numerator of Gc(s).
denc=[0 1];                         % Calculate denominator of Gc(s).
'Gc(s)'                             % Display label.
Gc=tf(numc,denc)                    % Create and display Gc(s).
'G(s)Gc(s)'                         % Display label.
Ge=G*Gc                             % Cascade G(s) and Gc(s).
rlocus(Ge,0:0.5:100)                % Plot root locus of PD compensated 
                                    % system.
sgrid(z,0)                          % Overlay desired percent overshoot 
                                    % line.
title(['PD Compensated Root Locus with ' , num2str(pos),...
'% Overshoot Line'])                % Add title to PD compensated root
                                    % locus.
[K,p]=rlocfind(Ge);                 % Generate gain, K, and closed-loop 
                                    % poles, p, for point selected 
                                    % interactively on the root locus.
'Closed-loop poles = '              % Display label.
p                                   % Display PD compensated system's
                                    % closed-loop poles.
f=input('Give pole number that is operating point   ');
                                    % Choose PD compensated system 
                                    % dominant pole.
'Summary of estimated specifications for selected point on PD' 
'compensated root locus'            % Display label.
operatingpoint=p(f)                 % Display PD compensated dominant
                                    % pole.
gain=K                              % Display PD compensated gain.
estimated_settling_time=4/abs(real(p(f)))
                                    % Display PD compensated settling
                                    % time.
estimated_peak_time=pi/abs(imag(p(f)))
                                    % Display PD compensated peak time.
estimated_percent_overshoot=pos     % Display PD compensated percent
                                    % overshoot.
estimated_damping_ratio=z           % Display PD compensated damping
                                    % ratio.
estimated_natural_frequency=sqrt(real(p(f))^2+imag(p(f))^2)
                                    % Display PD compensated natural
                                    % frequency.
s=tf([1 0],1);                      % Create transfer function, 's'.
sGe=s*Ge;                           % Create sGe(s).
sGe=minreal(sGe);                   % Cancel common poles and zeros.
Kv=dcgain(K*sGe)                    % Display compensated Kv.
ess=1/Kv                            % Display compensated steady-state 
                                    % error for unit ramp input.
'T(s)'                              % Display label.
T=feedback(K*Ge,1)                  % Create and display PD compensated 
                                    % T(s).
'Press any key to continue and obtain the PD compensated step response'
                                    % Display label.
pause
step(T)                             % Plot step response for PD 
                                    % compensated system.
title(['PD Compensated System Step Response with ' ,num2str(pos),...
'% Overshoot'])                     % Add title to step response of PD
                                    % compensated system.
