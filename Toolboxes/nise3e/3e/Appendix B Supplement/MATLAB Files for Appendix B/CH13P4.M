% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p4): We also can use MATLAB to convert G(z) to G(s) when G(s) is not in 
% cascade with a z.o.h. First, we create a sampled LTI transfer function, as
% discussed in ch13p3. The command, F = d2c(H,T,'zoh') transforms H(z) to F(s) 
% in cascade with a z.o.h., where H(z) = ((z-1)/z)*z{F(s)/s}. 
% If we consider F(s) = sG(s), the command solves for sG(s) given H(z). 
% Finally, sG(s)/s = G(s) yields the final result. In summary, form H(z), where 
% H(z) = ((z-1)/z)*G(z). Use F = d2c(H,T,'zoh') to find F(s) = sG(s). 
% Divide the result by s and obtain G(s). We convert G(z) = z/(z-0.3) into G(s). 
% You will enter T, the sampling interval, through the keyboard.


'(ch13p4)'                          % Display label.
T=input('Type T ');                 % Input sampling interval.
numgz=[1 0];                        % Define numerator of G(z).
dengz=[1 -.3];                      % Define denominator of G(z).
'G(z)'                              % Display label.
Gz=tf(numgz,dengz,T)                % Create and display G(z).
Hz=Gz*tf([1 -1],[1 0],T);           % Create H(z)=((z-1)/z)*G(z).
Hz=minreal(Hz);                     % Cancel common poles and zeros.	
Fs=d2c(Hz,'zoh');                   % Convert from H(z) to F(s)=sG(s).
Gs=Fs*tf(1,[1 0]);                  % Create G(s)=F(s)(1/s).
'G(s)'                              % Display label.
Gs=minreal(Gs)                      % Cancel common poles and zeros.
