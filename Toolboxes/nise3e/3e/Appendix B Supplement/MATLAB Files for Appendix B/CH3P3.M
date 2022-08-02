% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch3p3): The state-space representation consists of specifying the A, B, C, and 
% D matrices followed by the creation of an LTI state-space object using the MATLAB
% command, ss(A,B,C,D). Hence, for the matrices in (ch3p1) and (ch3p2), the 
% state-space representation would be:

'(ch3p3)'                           % Display label.
A=[0 1 0;0 0 1;-9 -8 -7];           % Represent A.
B=[7;8;9];                          % Represent column vector B.
C=[2 3 4];                          % Represent row vector C.
D=0;                                % Represent D.
F=ss(A,B,C,D)                       % Create an LTI object and display.

