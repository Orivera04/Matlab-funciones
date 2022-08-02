% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 3: Modeling in the Time Domain
%
% ch3sp1 (Example 3.6)     MATLAB's Symbolic Math Toolbox may
% be used to perform matrix operations. The code for these 
% operations is intuitive and readable. The operations are:
% addition(+), subtraction(-), inverse(^-1), matrix raised to 
% power n(^n). We demonstrate by solving Example 3.6 in the 
% text using Eq.(3.73) directly.

'(ch3sp1) Example 3.6'        % Display label.
syms s                        % Construct symbolic object for frequency
                              % variable 's'.
A=[0 1 0;0 0 1;-1 -2 -3];     % Create matrix A.
B=[10;0;0];                   % Create vector B.
C=[1 0 0];                    % Create vector C.
D=0;                          % Create D.
I=[1 0 0;0 1 0;0 0 1];        % Create identity matrix.
'T(s)'                        % Display label.
T=C*((s*I-A)^-1)*B+D;         % Find transfer function.
pretty(T)                     % Pretty print transfer function.
