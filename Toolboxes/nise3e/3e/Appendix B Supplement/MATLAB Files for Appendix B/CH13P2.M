% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p2): We also can use MATLAB to convert G(s) to G(z) when G(s) is not 
% in cascade with a z.o.h. The command, H = c2d(F,T,'zoh'), transforms F(s) in 
% cascade with a z.o.h. to H(z), where H(z) = ((z-1)/z)*z{F(s)/s}. If we let 
% F(s) = sG(s), the command solves for H(z), where H(z) = ((z-1)/z)*z{G(s)}. Hence, 
% z{G(s)} = (z/[z-1])*H(z). In summary, input F(s) = sG(s), and multiply the result of
% H = c2d(F,T,'zoh') by (z/[z-1]). This process is equivalent to finding the z-transform.
% We convert G(s) = (s+3)/(s^2+6s+13) into G(z). You will enter T, the sampling interval,
% through the keyboard. T is used to form H(z). We use an unspecified sampling interval,
% T = [] to form z/(z-1).


'(ch13p2)'                          % Display label.
T=input('Type T ');                 % Input sampling interval.
numgs=[1 3];                        % Define numerator of G(s).
dengs=[1 6 13];                     % Define denominator of G(s).
'G(s)'                              % Display label.
Gs=tf(numgs,dengs)                  % Create and display G(s).
Fs=Gs*tf([1 0],1);                  % Create F(s)=sG(s).	
Fs=minreal(Fs);                     % Cancel common poles and zeros.
Hz=c2d(Fs,T,'zoh');                 % Convert F(s) to H(z) assuming 
                                    % z.o.h.
Gz=Hz*tf([1 0],[1 -1],[]);          % Form G(z)=H(z)*z/(z-1).
'G(z)'                              % Display label.
Gz=minreal(Gz)                      % Cancel common poles and zeros.
