% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 7: Steady-State Errors
%
% (ch7p1) Example 7.4, sys. b: Static error constants are found using lim s^n*G(s) 
% as s->0. Once the static error constant is found, we can evaluate the 
% steady-state error. To evaluate the static error constant we can use the command 
% dcgain(G), which evaluates G(s) at s=0. Let us look at Example 7.4, system b, in 
% the text.

'(ch7p1) Example 7.4, sys. b'       % Display label.
numg=500*poly([-2 -5 -6]);          % Define numerator of G(s).
deng=poly([0 -8 -10 -12]);          % Define denominator of G(s).
G=tf(numg,deng);                    % Form G(s)
'Check Stability'                   % Display label.
T=feedback(G,1);                    % Form T(s).
poles=pole(T)                       % Display closed-loop poles.
'Step Input'                        % Display label.
Kp=dcgain(G)                        % Evaluate Kp=numg/deng for s=0.
ess=1/(1+Kp)                        % Evaluate ess for step input.
'Ramp Input'                        % Display label.
numsg=conv([1 0],numg);             % Define numerator of sG(s).
densg=poly([0 -8 -10 -12]);         % Define denominator of sG(s).
sG=tf(numsg,densg);                 % Create sG(s).
sG=minreal(sG);                     % Cancel common 's' in numerator(numsg)
                                    % and denominator(densg).
Kv=dcgain(sG)                       % Evaluate Kv=sG(s) for s=0.
ess=1/Kv                            % Evaluate steady-state error for 
                                    % ramp input.
'Parabolic Input'                   % Display label.
nums2g=conv([1 0 0],numg);          % Define numerator of s^2G(s).
dens2g=poly([-8 -10 -12]);          % Define denominator of s^2G(s).
s2G=tf(nums2g,dens2g);              % Create s^2G(s)
s2G=minreal(s2G);                   % Cancel common 's' in
                                    % numerator(nums2g) and 
                                    % denominator(dens2g).
Ka=dcgain(s2G)                      % Evaluate Ka=s^2G(s) for s=0.
ess=1/Ka                            % Evaluate steady-state error for 
                                    % parabolic input.
