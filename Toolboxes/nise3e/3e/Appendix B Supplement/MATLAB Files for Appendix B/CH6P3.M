% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch6p3) Example 6.11: We can use MATLAB to determine the stability of a system 
% represented in state space by using the command eig(A) to find the eigenvalues 
% of the system matrix, A. Let us apply the concept to Example 6.11 in the text.

'(ch6p3) Example 6.11'              % Display label.
A=[0 3 1;2 8 1;-10 -5 -2]           % Define system matrix, A.
eigenvalues=eig(A)                  % Find eigenvalues.
