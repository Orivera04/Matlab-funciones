% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p6) Example 13.9: We can use MATLAB's command dcgain(Gz) to find steady-state
% errors. The command evaluates the dc gain of Gz, a digital LTI transfer function object, 
% by evaluating Gz at z = 1. We use the dc gain to evaluate Kp, Kv, and Ka. Let us look at 
% Example 13.9 in the text. You will input T, the sampling interval, through the keyboard 
% to test stability.

'(ch13p6) Example 13.9'             % Display label.
T=input('Type T ');                 % Input sampling interval.
numg1s=[10];                        % Define numerator of G1(s).
deng1s=poly([0 -1]);                % Define denominator of G1(s).
'G1(s)'                             % Display label.
G1s=tf(numg1s,deng1s)               % Create and display G1(s).
'G(z)'                              % Display label.
Gz=c2d(G1s,T,'zoh')                 % Convert G1(s) and z.o.h. to G(z) 
                                    % and display.
'T(z)'                              % Display label.
Tz=feedback(Gz,1)                   % Create and display T(z).
'Closed-Loop z-Plane Poles'         % Display label.
r=pole(Tz)                          % Check stability.
M=abs(r)                            % Display magnitude of roots.
pause
Kp=dcgain(Gz)                       % Calculate Kp.
GzKv=Gz*(1/T)*tf([1 -1],[1 0],T);   % Multiply G(z) by (1/T)*(z-1). Also, 
                                    % divide G(z) by z which makes 
                                    % transfer function proper and yields
                                    % same Kv.
GzKv=minreal(GzKv,0.00001);         % Cancel common poles and zeros.
Kv=dcgain(GzKv)                     % Calculate Kv.
GzKa=Gz*(1/T^2)*tf([1 -2 1],[1 0 0],T);		
                                    % Multiply G(z) by (1/T^2)(z-1)^2.
                                    % Also, divide G(z) by z^2 which
                                    % makes the transfer function proper
                                    % and yields the same Ka.
GzKa=minreal(GzKa,0.00001);         % Cancel common poles and zeros.
Ka=dcgain(GzKa)                     % Calculate Ka.
