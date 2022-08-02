% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 13: Digital Control Systems
%
% (ch13p1) Example 13.4:  We can convert G1(s) in cascade with a 
% zero-order hold (z.o.h.) to G(z) using MATLAB's G = c2d(G1,T,'zoh') command,
% where G1 is an LTI continuous-system object and G is an LTI sampled-system object. 
% T is the sampling interval and 'zoh' is a method of transformation that assumes
% G1(s) in cascade with a z.o.h. We simply put G1(s) into the command (the 
% z.o.h. is automatically taken care of) and the command returns G(z).
% Let us apply the concept to Example 13.4. You will enter T through the 
% keyboard.

'(ch13p1) Example 13.4'             % Display label.
T=input('Type T ');                 % Input sampling interval.
numg1s=[1 2];                       % Define numerator of G1(s).
deng1s=[1 1];                       % Define denominator of G1(s).
'G1(s)'                             % Display label.
G1=tf(numg1s,deng1s)                % Create G1(s) and display.
'G(z)'                              % Display label.
G=c2d(G1,T,'zoh')                   % Convert G1(s) in cascade with 
                                    % z.o.h. to G(z) and display.
