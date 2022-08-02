% Script p1_3_03.m; pseudo-inverse solution to
% a set of linear equations; example of 2 eqns. 
% with 3 unknowns;                5/98, 3/30/02
%
A=[1 2 3; 1 -1 2]; b=[10 10]';
%
% Using analytical solution:
x=A'*((A*A')\b)
%
% Using 'pinv' command:
disp('Using PINV command in MATLAB')
x=pinv(A)*b
