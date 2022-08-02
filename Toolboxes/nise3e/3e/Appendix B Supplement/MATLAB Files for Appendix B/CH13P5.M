% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p5) Example 13.6: We can use MATLAB to find the gain for stability. Let us 
% look at Example 13.6 in the text.

'(ch13p5) Example 13.6'             % Display label.
numgas=27;                          % Define numerator of Ga(s).
dengas=[1 27 0];                    % Define denominator of Ga(s).
'Ga(s)'                             % Display label.
Ga=tf(numgas,dengas)                % Create and display Ga(s).
'G(z)'                              % Display label.
Gz=c2d(Ga,0.1,'zoh')                % Find G(z) assuming Ga(s) in
                                    % cascade with z.o.h. and display.
for K=1:0.1:50;                     % Set range of K to look for
                                    % stability.
Tz=feedback(K*Gz,1);                % Find T(z).
r=pole(Tz);                         % Get poles for this value of K.
rm=max(abs(r));                     % Find pole with maximum absolute 
                                    % value for this value of K.
if rm>=1;                           % See if pole is outside unit circle.
break;                              % Stop if pole is found outside unit 
                                    % circle.
end;                                % End if.
end;                                % End for.
K                                   % Display K value.
r                                   % Display closed-loop poles for this 
                                    % value of K.
rm                                  % Display absolute value of pole.
