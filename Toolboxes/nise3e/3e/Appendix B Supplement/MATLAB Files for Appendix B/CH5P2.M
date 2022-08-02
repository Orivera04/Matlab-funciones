% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch5p2) Example 5.3: We can use MATLAB to calculate the closed-loop 
% characteristics of a second-order system such as damping ratio, z; natural 
% frequency, wn; percent overshoot, %OS (pos); settling time, Ts; and peak time,  
% Tp. The command [numt,dent] = tfdata(T,'v') extracts the numerator and 
% denominator of T(s) for a single-input/single-output system from which the 
% calculations are based. The argument 'v' returns the numerator and denominator
% as simple row vectors. Omitting 'v' would return the numerator and denominator 
% as cell arrays requiring more steps to obtain the row vectors. We end by 
% generating a plot of the closed-loop step response. Let us look 
% at Example 5.3 in the text. 

'(ch5p2) Example 5.3'               % Display label.
numg=[25];                          % Define numerator of G(s).
deng=poly([0 -5]);                  % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
'T(s)'                              % Display label.
T=feedback(G,1)                     % Find T(s).
[numt,dent]=tfdata(T,'v');          % Extract numerator & denominator of 
                                    % T(s).
wn=sqrt(dent(3))                    % Find natural frequency.
z=dent(2)/(2*wn)                    % Find damping ratio.
Ts=4/(z*wn)                         % Find settling time.
Tp=pi/(wn*sqrt(1-z^2))              % Find peak time.
pos=exp(-z*pi/sqrt(1-z^2))*100      % Find percent overshoot.
step(T)                             % Generate step response.

																												
