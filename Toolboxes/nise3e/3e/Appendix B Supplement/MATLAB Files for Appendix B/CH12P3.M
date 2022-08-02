% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch12p3) Example 12.4: If we design controller gains using MATLAB, we do not 
% have to convert to phase-variable form. MATLAB will give us the controller gains 
% for any state-space representation we input.  Let us look at Example 12.4 in the 
% text.

'(ch12p3) Example 12.4'             % Display label.
clf                                 % Clear graph on screen.
A=[-5 1 0;0 -2 1;0 0 -1];           % Define system matrix A.
B=[0;0;1];                          % Define input matrix B.
C=[-1 1 0];                         % Define output matrix C.
D=0;                                % Define matrix D.
pos=input('Type desired %OS  ');    % Input desired percent overshoot.
Ts=input('Type desired settling time   ');
                                    % Input desired settling time.
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
wn=4/(z*Ts);                        % Calculate required natural 
                                    % frequency.
[num,den]=ord2(wn,z);               % Produce a second-order system that 
                                    % meets the transient requirements.
r=roots(den);                       % Use denominator to specify dominant 
                                    % poles.
poles=[r(1) r(2) -4];               % Specify pole placement for all 
                                    % poles.
K=acker(A,B,poles)                  % Calculate controller gains.
Anew=A-B*K;                         % Form compensated A matrix.
Bnew=B;                             % Form compensated B matrix.
Cnew=C;                             % Form compensated C matrix.
Dnew=D;                             % Form compensated D matrix.
Tss=ss(Anew,Bnew,Cnew,Dnew);        % Form LTI state-space object.
'T(s)'                              % Display label.
T=tf(Tss);                          % Create T(s).
T=minreal(T)                        % Cancel common terms and display 
                                    % T(s).
poles=pole(T)                       % Display poles of T(s).
step(Tss)                           % Produce compensated step response.
title('Compensated Step Response')  % Add title to compensated step 
                                    % response.
