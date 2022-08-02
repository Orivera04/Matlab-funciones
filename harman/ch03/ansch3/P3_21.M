% P3_21.M Solve for currents I in the equation
%   A*I=b; (This file displays the values of A, b and I) 
%
A=[10 -9 0;-9 20 -9;0 -9 15]
b=[100 0 0]'
I=A\b
%
% Improve the M-file by adding text to the output
% You might also want to make this a function I=fsolve(A,b)
%