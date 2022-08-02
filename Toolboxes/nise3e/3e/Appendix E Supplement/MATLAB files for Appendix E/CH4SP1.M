%  Nise, N.S. 
%  Control Systems Engineering, 3rd ed. 
%  John Wiley & Sons, New York, NY, 10158-0012
% 
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 4: Time Response
%
% ch4sp1 (Example 4.11)     MATLAB's Symbolic Math Toolbox, with 
% its ability to perform matrix operations, lends itself to the 
% Laplace transform solution of state equations. Also, the 
% command [V,D]=eig(A) allows us to find the eigenvalues  
% of a square matrix, A, which are the diagonal elements of 
% diagonal matrix D. We demonstrate by solving  Example 4.11.

'(ch4sp1) Example 4.11'       % Display label.
syms s                        % Construct symbolic object for frequency
                              % variable 's'.
'a'                           % Display label.
A=[0 1 0;0 0 1;-24 -26 -9];   % Create matrix A.
B=[0;0;1];                    % Create vector B.
X0=[1;0;2];                   % Create initial condition vector,X(0).
U=1/(s+1);                    % Create U(s).
I=[1 0 0;0 1 0;0 0 1];        % Create identity matrix.
X=((s*I-A)^-1)*(X0+B*U);      % Find Laplace transform of state vector.
x1=ilaplace(X(1));            % Solve for X1(t).
x2=ilaplace(X(2));            % Solve for X2(t).
x3=ilaplace(X(3));            % Solve for X3(t).
y=x1+x2;                      % Solve for output, y(t).
y=vpa(y,3);                   % Convert fractions to decimals.
'y(t)'                        % Display label.
pretty(y)                     % Pretty print y(t).
'b'                           % Display label.
[V,D]=eig(A);                 % Find eigenvalues, which are the diagonal
                              % elements of D.
'Eigenvalues on diagonal'     % Display label.
D                             % Display D.
