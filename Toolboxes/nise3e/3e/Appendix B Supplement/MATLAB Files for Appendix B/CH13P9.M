% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch13p9 (Example 13.12):    Let us now use MATLAB to design a digital lead 
% compensator. The s-plane design was performed in Example 9.6. Here we convert 
% the design to the z-plane and run a digital simulation of the step response. 
% Conversion of the s-plane lead compensator, Gc(s) = numgcs/dengcs, to the 
% z-plane compensator, Gc(z) = numgcz/dengcz, is accomplished using the 
% Gcz = c2d(numgcs,dengcs,T,'tustin') command to perform a Tustin transformation, 
% where T = sampling interval, which for this example is 1/300. This exercise 
% solves Example 13.12 using MATLAB.


'(ch13p9) Example 13.12'                        % Display label.
clf                                             % Clear graph.
T=0.01                                          % Define sampling interval.
numgcs=1977*[1 6];                              % Define numerator of Gc(s).
dengcs=[1 29.1];                                % Define denominator of Gc(s).
'Gc(s) in polynomial form'                      % Print label.
Gcs=tf(numgcs,dengcs)                           % Create Gc(s) in polynomial form 
                                                % and display.
'Gc(s) in polynomial form'                      % Display label.
Gcszpk=zpk(Gcs)                                 % Create Gc(s) in factored form
                                                % and display.
'Gc(z) in polynomial form via Tustin Transformation'               
                                                % Display label.
Gcz=c2d(Gcs,T,'tustin')                         % Form Gc(z) via Tustin transformation.
'Gc(z) in factored form via Tustin Transformation'
                                                % Display label.
Gczzpk=zpk(Gcz)                                 % Show Gc(z) in factored form.
numgps=1;                                       % Define numerator of Gp(s).
dengps=poly([0	-6	-10]);                        % Define denominator of Gp(s).
'Gp(s) in polynomial form'                      % Display label.
Gps=tf(numgps,dengps)                           % Create Gp(s) in polynomial form
                                                % and display.
'Gp(s) in factored form'                        % Display label.
Gpszpk=zpk(Gps)                                 % Create Gp(s) in factored form
                                                % and display.
'Gp(z) in polynomial form'                      % Display label.
Gpz=c2d(Gps,T,'zoh')                            % Form Gp(z) via zoh transformation.
'Gp(z) in factored form'                        % Display label.
Gpzzpk=zpk(Gpz)                                 % Form Gp(z) in factored form.
Gez=Gcz*Gpz;                                    % Form Ge(z) = Gc(z)Gp(z).
'Ge(z) = Gc(z)Gp(z) in factored form'           % Display label.
Gezzpk=zpk(Gez)                                 % Form Ge(z) in factored form
                                                % and display.
'z-1'                                           % Display label.
zm1=tf([1 -1],1,T)                              % Form z-1.
zm1Gez=minreal(zm1*Gez,0.00001);                % Cancel common factors.
'(z-1)Ge(z) for finding steady-state error'     % Display label.
zm1Gezzpk=zpk(zm1Gez)                           % Form & display (z-1)Ge(z) in
                                                % factored form.
Kv=(1/T)*dcgain(zm1Gez)                         % Find Kv.
'T(z) = Ge(z)/(1+Ge(z))'                        % Display label.
Tz=feedback(Gez,1)                              % Find closed-loop 
                                                % transfer function, T(z)
step(Tz,0:T:2)                                  % Find step reponse.
title('Closed-Loop Digital Lead Compensated Step Response')     
                                                % Add title to step response.
