% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch9p2) Example 9.4: We can use MATLAB to design a lead compensator. The 
% program allows us to input a desired percent overshoot via the keyboard. MATLAB 
% then produces a root locus for the uncompensated system with an overlay of the 
% percent overshoot line. We interactively select the intersection of the root 
% locus and the desired percent overshoot line to set the gain. MATLAB outputs an 
% estimate of the uncompensated system's performance specifications and a step 
% response of the uncompensated system for us to determine the required settling 
% time. Next, we input the settling time and the lead compensator zero through the 
% keyboard. At this point, we take a different approach from that of the previous 
% example. Rather than letting MATLAB calculate the lead compensator pole directly, 
% MATLAB produces a root locus for every interactive guess of a lead compensator pole. 
% Each root locus contains the desired damping ratio and natural frequency curves. 
% When our guess is correct, the root locus, the damping ratio line, and the 
% natural frequency curve will intersect. We then interactively select this point 
% of intersection to input the gain. Finally, MATLAB produces an estimate of the 
% lead compensated system's performance specifications and a step response of the 
% lead compensated system.

'(ch9p2) Example 9.4'               % Display label.
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
'% overshoot Line'])                % Title uncompensated root locus.
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
T=feedback(K*G,1)                   % Create and display T(s).	
step(T)                             % Plot step response of uncompensated 
                                    % system.
title(['Uncompensated System Step Response with ' ,num2str(pos),...
'% overshoot'])                     % Add title to uncompensated step 
                                    % response.
'Press any key to go to lead compensation'
                                    % Display label.
pause
Ts=input('Type Desired Settling Time ');
                                    % Input desired settling time.
b=input('Type Lead Compensator Zero, (s+b). b=  ');
                                    % Input lead compensator zero.
done=1;                             % Set loop flag.
while done==1                       % Start loop for trying lead 
                                    % compensator pole. 
a=input('Enter a Test Lead Compensator Pole, (s+a). a =     ');
                                    % Enter test lead compensator pole.
numge=conv(numg,[1 b]);             % Generate numerator of Gc(s)G(s).
denge=conv([1 a],deng);             % Generate denominator of Gc(s)G(s).
Ge=tf(numge,denge);                 % Create Ge(s)=Gc(s)G(s).
wn=4/(Ts*z);                        % Evaluate desired natural frequency.
clf                                 % Clear graph on screen.
rlocus(Ge)                          % Plot compensated root locus with 
                                    % test lead compensator pole.
axis([-10,10,-10,10])               % Change lead-compensated root locus 
                                    % axes.
sgrid(z,wn)                         % Overlay grid on lead-compensated 
                                    % root locus.
title(['Lead-Compensated Root Locus with ' , num2str(pos),...
'% Overshoot Line, Lead Pole at ', num2str(-a),...
' and Required Wn'])                % Add title to lead-compensated root 
                                    % locus.
done=input('Are you done? (y=0,n=1)  ');
                                    % Set loop flag.
end                                 % End loop for trying compensator 
                                    % pole.
[K,p]=rlocfind(Ge);                 % Generate gain, K, and closed-loop 
                                    % poles, p, for point selected 
                                    % interactively on the root locus.
'Gc(s)'                             % Display label.
Gc=tf([1 b],[1 a])                  % Display lead compensator.
'Gc(s)G(s)'                         % Display label.
Ge                                  % Display Gc(s)G(s).
'Closed-loop poles = '              % Display label.
p                                   % Display lead-compensated system's 
                                    % closed-loop poles.
f=input('Give pole number that is operating point   ');
                                    % Choose lead-compensated system 
                                    % dominant pole.
'Summary of estimated specifications for selected point on lead'
'compensated root locus'            % Display label.
operatingpoint=p(f)                 % Display lead-compensated dominant 
                                    % pole.
gain=K                              % Display lead-compensated gain.
estimated_settling_time=4/abs(real(p(f)))
                                    % Display lead-compensated settling 
                                    % time.
estimated_peak_time=pi/abs(imag(p(f)))
                                    % Display lead-compensated peak time.
estimated_percent_overshoot=pos     % Display lead-compensated percent 
                                    % overshoot.
estimated_damping_ratio=z           % Display lead-compensated damping 
                                    % ratio.
estimated_natural_frequency=sqrt(real(p(f))^2+imag(p(f))^2)
                                    % Display lead-compensated natural 
                                    % frequency.
s=tf([1 0],1);                      % Create transfer function, 's'.
sGe=s*Ge;                           % Create sGe(s) to evaluate Kv.
sGe=minreal(sGe);                   % Cancel common poles and zeros.
Kv=dcgain(K*sGe)                    % Display lead-compensated Kv.
ess=1/Kv                            % Display lead-compensated steady-
                                    % state error for unit ramp input.
'T(s)'                              % Display label.
T=feedback(K*Ge,1)                  % Create and display lead-compensated 
                                    % T(s).
'Press any key to continue and obtain the lead-compensated step'
'response'                          % Display label
pause
step(T)                             % Plot step response for lead 
                                    % compensated system.
title(['Lead-Compensated System Step Response with ' ,num2str(pos),...
'% overshoot'])                     % Add title to step response of lead- 
                                    % compensated system.
