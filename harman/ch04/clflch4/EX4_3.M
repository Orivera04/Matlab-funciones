% EX4_3.M  Check Example 4.3 using roots, factor and solve 
%  Also, see what MATLAB does with third order eq.
%   defined symbolically 'a1*x^3+a*x^2+b*x+c=0'
%  This script requires the Symbolic Math toolbox
clear
%  Find roots and Factor polynomials
%   z^4-4*z^3+6*z^2-4*z+1
P1=[1 -4 6 -4 1]	% Coefficients
format long
P1roots=roots(P1)       % Note accuracy and complex numbers
fprintf('Note the accuracy of the result- answer is [1 1 1 1] \n')
z=sym('z')
P1factor=factor(z^4-4*z^3+6*z^2-4*z+1)
pause
%
P2='z^2+1'              % Symbolic polynomial z^2+1        
P2factor=factor(z^2+1)        
P2roots=solve(z^2+1)  
pause
%
%  Try the cubic
syms x a1 a b c
x3ans=solve(a1*x^3+a*x^2+b*x+c)	% Roots of cubic equation
%
%
%  Try simple and pretty command to simplify the MATLAB
%  symbolic result. Also, try a simple cubic
%    such as x^3+3*x^2+3*x+1=0.
%      i.e., x3ans1=solve('x^3+3*x^2+3*x+1')
%
% For Version 5  Added sym commands and changed call to factor and solve